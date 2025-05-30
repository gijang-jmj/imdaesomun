import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/helpers/exception_helper.dart';
import 'package:imdaesomun/src/core/services/loading_service.dart';
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
      ref.read(globalLoadingProvider.notifier).start();
      final userCredential = await ref
          .read(userRepositoryProvider)
          .signIn(email: email, password: password);
      final user = userCredential.user;
      onSuccess('로그인에 성공했어요');
      ref
          .read(logProvider.notifier)
          .log('[LoginDialogViewModel]\n\nonLogin success:\n$user');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '로그인 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nonLogin error:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('로그인 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nonLogin error:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  void onSignUp({
    required String email,
    required String password,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      ref.read(globalLoadingProvider.notifier).start();
      await ref
          .read(userRepositoryProvider)
          .signUp(email: email, password: password);
      await ref.read(userRepositoryProvider).sendEmailVerification();
      onSuccess('회원가입이 완료되었어요!\n인증 메일을 확인해주세요');
      ref
          .read(logProvider.notifier)
          .log('[LoginDialogViewModel]\n\nonSignUp success:\n$email');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '회원가입 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nonSignUp error:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('회원가입 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nonSignUp error:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }
}

final loginDialogViewModelProvider =
    NotifierProvider.autoDispose<LoginDialogViewModel, LoginState>(
      LoginDialogViewModel.new,
    );
