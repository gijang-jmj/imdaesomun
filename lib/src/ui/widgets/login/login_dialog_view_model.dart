import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_state.dart';

class LoginDialogViewModel extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    {
      return LoginState(obscure: true);
    }
  }

  void toggleObscure() {
    state = state.copyWith(obscure: !state.obscure);
  }

  void onLogin({required String email, required String password}) async {
    // 로그인 로직을 여기에 작성
    // 예: FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  void onSignUp({required String email, required String password}) async {
    try {
      print('onSignUp');
      await ref
          .read(userRepositoryProvider)
          .signUpWithEmail(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ref
            .read(globalToastProvider.notifier)
            .showToast('6자리 이상의 비밀번호를 입력해주세요');
      } else if (e.code == 'email-already-in-use') {
        ref
            .read(globalToastProvider.notifier)
            .showToast('이미 사용 중인 이메일이에요\n비밀번호를 잊으셨다면 재설정해주세요');
      }
    } catch (e) {
      ref
          .read(globalToastProvider.notifier)
          .showToast('회원가입 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel] onLogin error:\n\n$e',
            type: LogType.error,
          );
    }
  }
}

final loginDialogViewModelProvider =
    NotifierProvider.autoDispose<LoginDialogViewModel, LoginState>(
      LoginDialogViewModel.new,
    );
