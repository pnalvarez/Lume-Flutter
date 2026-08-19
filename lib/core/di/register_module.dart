import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/auth/auth_token_provider.dart';

@module
abstract class CoreAuthModule {
  @lazySingleton
  IAuthTokenProvider authTokenProvider(IAuthSessionProvider session) => session;
}
