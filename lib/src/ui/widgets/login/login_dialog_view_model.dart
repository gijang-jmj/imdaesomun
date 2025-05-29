import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
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

  void onLogin({
    required String email,
    required String password,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      final userCredential = await ref
          .read(userRepositoryProvider)
          .signIn(email: email, password: password);
      final user = userCredential.user;
      ref
          .read(logProvider.notifier)
          .log('[LoginDialogViewModel] onLogin success:\n\n$user');
      onSuccess('로그인에 성공했어요');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        onError('이메일 또는 비밀번호를 확인해주세요');
      } else if (e.code == 'user-not-found') {
        onError('존재하지 않는 계정이에요');
      } else if (e.code == 'wrong-password') {
        onError('일치하지 않은 비밀번호에요');
      } else if (e.code == 'too-many-requests') {
        onError('너무 많은 요청이 들어왔어요\n잠시 후 다시 시도해주세요');
      } else if (e.code == 'invalid-email') {
        onError('유효하지 않은 이메일 형식이에요');
      } else {
        onError('로그인 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
        ref
            .read(logProvider.notifier)
            .log(
              '[LoginDialogViewModel] onLogin error:\n\n$e',
              type: LogType.error,
            );
      }
    } catch (e) {
      onError('로그인 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel] onLogin error:\n\n$e',
            type: LogType.error,
          );
    }
  }

  void onSignUp({
    required String email,
    required String password,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      await ref
          .read(userRepositoryProvider)
          .signUp(email: email, password: password);
      await ref.read(userRepositoryProvider).sendEmailVerification();
      onSuccess('회원가입이 완료되었어요!\n인증 메일을 확인해주세요');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError('6자리 이상의 비밀번호를 입력해주세요');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 사용 중인 이메일이에요');
      } else if (e.code == 'too-many-requests') {
        onError('너무 많은 요청이 들어왔어요\n잠시 후 다시 시도해주세요');
      } else if (e.code == 'invalid-email') {
        onError('유효하지 않은 이메일 형식이에요');
      } else {
        onError('회원가입 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
        ref
            .read(logProvider.notifier)
            .log(
              '[LoginDialogViewModel] onLogin error:\n\n$e',
              type: LogType.error,
            );
      }
    } catch (e) {
      onError('회원가입 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
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
