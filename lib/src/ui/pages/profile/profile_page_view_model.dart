import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/helpers/exception_helper.dart';
import 'package:imdaesomun/src/core/services/loading_service.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/utils/validate_util.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';

class ProfilePageViewModel extends AsyncNotifier<bool> {
  Future<void> getPushAllowed() async {
    try {
      final token = ref.read(fcmTokenStateProvider);
      if (token == null) {
        state = AsyncValue.data(false);
        return;
      }
      final isPushAllowed = await ref
          .read(userRepositoryProvider)
          .getPushAllowed(token: token);
      state = AsyncValue.data(isPushAllowed);
    } catch (e) {
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\ngetPushAllowed failed\n\nerror:\n$e',
            type: LogType.error,
          );
    }
  }

  @override
  Future<bool> build() async {
    final token = ref.read(fcmTokenStateProvider);
    if (token == null) {
      return false;
    }
    return await ref.read(userRepositoryProvider).getPushAllowed(token: token);
  }

  void signOut({
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      await ref.read(userRepositoryProvider).signOut();
      onSuccess('로그아웃에 성공했어요');
      ref
          .read(logProvider.notifier)
          .log('[ProfilePageViewModel]\n\nsignOut success');
    } catch (e) {
      onError('로그아웃 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nsignOut failed\n\nerror:\n$e',
            type: LogType.error,
          );
    }
  }

  void updateDisplayName({
    required String displayName,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      if (displayName.length < 2) {
        onError('두 글자 이상 입력해 주세요');
        return;
      }

      if (ValidateUtil.isContainSpecialCharacter(displayName)) {
        onError('특수문자를 제외하고 입력해주세요');
        return;
      }

      if (ValidateUtil.containsKoreanConsonantVowel(displayName)) {
        onError('완성된 글자로 입력해주세요');
        return;
      }

      ref.read(globalLoadingProvider.notifier).start();
      await ref
          .read(userRepositoryProvider)
          .updateUserDisplayName(displayName: displayName);
      await ref.read(userRepositoryProvider).reloadUser();
      ref.invalidate(firebaseAuthStateChangesProvider);
      onSuccess('닉네임 변경에 성공했어요');
      ref
          .read(logProvider.notifier)
          .log('[ProfilePageViewModel]\n\nupdateDisplayName success');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '닉네임 변경 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nupdateDisplayName failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('닉네임 변경 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nupdateDisplayName failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  void verifyEmail({
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      ref.read(globalLoadingProvider.notifier).start();
      await ref.read(userRepositoryProvider).reloadUser();
      ref.invalidate(firebaseAuthStateChangesProvider);
      final user = await ref.refresh(firebaseAuthStateChangesProvider.future);

      if (user != null && user.emailVerified) {
        onSuccess('이메일 인증이 완료되었어요');
        ref
            .read(logProvider.notifier)
            .log('[ProfilePageViewModel]\n\nverifyEmail success');
      } else {
        onError('이메일 인증이 완료되지 않았어요');
        ref
            .read(logProvider.notifier)
            .log('[ProfilePageViewModel]\n\nverifyEmail failed\n\nnot yet');
      }
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '이메일 인증 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nverifyEmail failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('이메일 인증 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nverifyEmail failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  void sendEmailVerification({
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      ref.read(globalLoadingProvider.notifier).start();
      await ref.read(userRepositoryProvider).sendEmailVerification();
      onSuccess('인증 메일을 재발송했어요');
      ref
          .read(logProvider.notifier)
          .log('[ProfilePageViewModel]\n\nsendEmailVerification success');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '재발송 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nsendEmailVerification failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('재발송 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nsendEmailVerification failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  void deleteAccount({
    required String password,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onError,
  }) async {
    try {
      ref.read(globalLoadingProvider.notifier).start();
      await ref.read(userRepositoryProvider).deleteUser(password: password);
      onSuccess('회원 탈퇴에 성공했어요');
      ref
          .read(logProvider.notifier)
          .log('[ProfilePageViewModel]\n\ndeleteAccount success');
    } on FirebaseAuthException catch (e) {
      final msg =
          ExceptionHelper.getFirebaseAuthMessage(e) ??
          '회원 탈퇴 중 오류가 발생했어요\n잠시 후 다시 시도해주세요';

      onError(msg);
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\ndeleteAccount failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } catch (e) {
      onError('회원 탈퇴 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\ndeleteAccount failed\n\nerror:\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }

  void togglePushAllowed({required bool allowed}) async {
    try {
      state = AsyncValue.data(allowed);
      final token = ref.read(fcmTokenStateProvider);
      if (token == null) {
        state = AsyncValue.data(allowed);
        return;
      }
      await ref
          .read(userRepositoryProvider)
          .setPushAllowed(token: token, allowed: allowed);
      getPushAllowed();
    } catch (e) {
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\ntogglePushAllowed failed\n\nerror:\n$e',
            type: LogType.error,
          );
    }
  }
}

final profilePageViewModelProvider =
    AsyncNotifierProvider<ProfilePageViewModel, bool>(ProfilePageViewModel.new);
