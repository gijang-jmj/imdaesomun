import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/helpers/exception_helper.dart';
import 'package:imdaesomun/src/core/services/loading_service.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/utils/validate_util.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog_state.dart';

class LoginDialogViewModel extends AutoDisposeNotifier<LoginDialogState> {
  @override
  LoginDialogState build() {
    {
      return LoginDialogState(obscure: true, email: '', password: '');
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

  void resetPassword({
    required String email,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      ref.read(globalLoadingProvider.notifier).start();
      await ref.read(userRepositoryProvider).resetPassword(email: email);
      onSuccess('비밀번호 재설정 메일을 발송했어요');
      ref
          .read(logProvider.notifier)
          .log('[LoginDialogViewModel]\n\nresetPassword success:\n$email');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '비밀번호 재설정 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nresetPassword error:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('비밀번호 재설정 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[LoginDialogViewModel]\n\nresetPassword error:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (ValidateUtil.isValidEmail(value) == false) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다';
    }
    return null;
  }
}

final loginDialogViewModelProvider =
    NotifierProvider.autoDispose<LoginDialogViewModel, LoginDialogState>(
      LoginDialogViewModel.new,
    );
