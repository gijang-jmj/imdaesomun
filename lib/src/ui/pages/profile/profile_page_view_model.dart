import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/helpers/exception_helper.dart';
import 'package:imdaesomun/src/core/providers/loading_provider.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';
import 'package:imdaesomun/src/core/providers/toast_provider.dart';
import 'package:imdaesomun/src/core/services/permission_service.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/core/utils/validate_util.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePageViewModel extends AsyncNotifier<bool> {
  void setPushAllowed({required bool allowed}) {
    Debounce.call(
      'setPushAllowed',
      const Duration(milliseconds: 500),
      () async {
        try {
          final token = ref.read(fcmTokenProvider);

          if (token == null) {
            state = AsyncValue.data(false);
            return;
          }

          await ref
              .read(userRepositoryProvider)
              .setPushAllowed(token: token, allowed: allowed);
        } catch (e, st) {
          ref
              .read(logProvider.notifier)
              .log(
                '[ProfilePageViewModel]\n\nsetPushAllowed failed',
                error: e.toString(),
                stackTrace: st,
              );
          state = AsyncValue.data(false);
        }
      },
    );
  }

  @override
  Future<bool> build() async {
    try {
      final status = await PermissionService.getPushStatus();

      if (status != AuthorizationStatus.authorized) {
        return false;
      }

      final token = ref.read(fcmTokenProvider);

      if (token == null) {
        return false;
      }

      return await ref
          .read(userRepositoryProvider)
          .getPushAllowed(token: token);
    } catch (e, st) {
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nbuild failed',
            error: e.toString(),
            stackTrace: st,
          );
      return false;
    }
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
    final status = await PermissionService.getPushStatus();
    final permission = await PermissionService.requestPushPermission();

    if (Platform.isIOS &&
        status == AuthorizationStatus.notDetermined &&
        permission == false) {
      state = AsyncValue.data(false);
      ref.read(globalToastProvider.notifier).showToast('푸시 알림 권한을 허용해주세요');
      return;
    }

    if (status == AuthorizationStatus.denied && permission == false) {
      openAppSettings();
      return;
    }

    state = AsyncValue.data(allowed);
    setPushAllowed(allowed: allowed);
  }
}

final profilePageViewModelProvider =
    AsyncNotifierProvider<ProfilePageViewModel, bool>(ProfilePageViewModel.new);
