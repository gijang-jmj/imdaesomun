import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/helpers/exception_helper.dart';
import 'package:imdaesomun/src/core/services/loading_service.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';

class ProfilePageViewModel extends Notifier {
  @override
  void build() {}

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
      final user = await ref.read(userRepositoryProvider).reloadUser();
      ref.invalidate(firebaseAuthStateChangesProvider);

      if (user.emailVerified) {
        onSuccess('이메일 인증에 성공했어요');
        ref
            .read(logProvider.notifier)
            .log('[ProfilePageViewModel]\n\nverifyEmail success');
      } else {
        onError('이메일 인증되지 않았어요\n재발송을 시도해주세요');
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
}

final profilePageViewModelProvider =
    NotifierProvider<ProfilePageViewModel, void>(ProfilePageViewModel.new);
