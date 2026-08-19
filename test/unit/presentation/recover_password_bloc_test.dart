import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/request_password_recovery.dart';
import 'package:lume/layers/presentation/screens/recover_password/recover_password_bloc.dart';
import 'package:lume/layers/presentation/screens/recover_password/recover_password_event.dart';
import 'package:lume/layers/presentation/screens/recover_password/recover_password_state.dart';

class _Request implements IRequestPasswordRecovery {
  var calls = 0;

  @override
  Future<void> call({required String email}) async {
    calls += 1;
  }
}

void main() {
  blocTest<RecoverPasswordBloc, RecoverPasswordState>(
    'submit sends the recovery email and marks sent',
    build: () => RecoverPasswordBloc(requestPasswordRecovery: _Request()),
    act: (bloc) {
      bloc
        ..add(const RecoverPasswordEmailChanged('ada@example.com'))
        ..add(const RecoverPasswordSubmitted());
    },
    skip: 1,
    expect: () => [
      isA<RecoverPasswordState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<RecoverPasswordState>().having((s) => s.sent, 'sent', true),
    ],
  );
}
