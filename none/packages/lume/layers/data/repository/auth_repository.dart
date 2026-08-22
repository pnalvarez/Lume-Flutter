import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/config/app_config.dart';
import 'package:lume/layers/data/datasource/auth_data_source.dart';
import 'package:lume/layers/data/mappers/auth_mapper.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

@Injectable(as: IAuthRepository)
final class AuthRepository implements IAuthRepository {
  AuthRepository(this._dataSource, this._session, this._config);

  final IAuthDataSource _dataSource;
  final IAuthSessionProvider _session;
  final AppConfig _config;

  @override
  AuthSession? get currentSession {
    return AuthMapper.toDomain(
      _session.session,
      isPasswordRecovery: _session.isPasswordRecovery,
    );
  }

  @override
  Stream<AuthSession?> observe() {
    return _session.changes.map((_) => currentSession);
  }

  @override
  Future<AuthSession?> restore() async {
    await _session.restore();
    return currentSession;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final snapshot = await _dataSource.signIn(email: email, password: password);
    await _session.restore();
    // Password login must not keep a stale recovery gate from an earlier
    // deep link; recovery links set the flag via [AuthChangeKind.passwordRecovery].
    _session.clearPasswordRecovery();
    return AuthMapper.toDomainOrThrow(
      _session.session ?? snapshot,
      isPasswordRecovery: false,
    );
  }

  @override
  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    final result = await _dataSource.signUp(
      email: email,
      password: password,
      emailRedirectTo: _config.authCallbackUrl,
    );
    if (result.session != null && result.isEmailConfirmed) {
      return AuthSignUpResult(
        session: AuthMapper.toDomainOrThrow(
          result.session!,
          isPasswordRecovery: false,
        ),
        email: result.email ?? email,
        needsEmailConfirmation: false,
      );
    }
    if (result.session != null) {
      await _dataSource.signOut();
    }
    return AuthSignUpResult(
      email: result.email ?? email,
      needsEmailConfirmation: true,
    );
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> resendConfirmationEmail({required String email}) {
    return _dataSource.resendSignupEmail(
      email: email,
      emailRedirectTo: _config.authCallbackUrl,
    );
  }

  @override
  Future<void> requestPasswordRecovery({required String email}) {
    return _dataSource.resetPasswordForEmail(
      email: email,
      redirectTo: _config.passwordRecoveryUrl,
    );
  }

  @override
  Future<void> updatePassword({required String password}) {
    return _dataSource.updatePassword(password: password);
  }

  @override
  void clearPasswordRecovery() => _session.clearPasswordRecovery();
}
