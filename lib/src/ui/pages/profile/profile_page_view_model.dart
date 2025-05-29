import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/loading_service.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
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
      ref.invalidate(firebaseAuthUserProvider);
      onSuccess('닉네임 변경에 성공했어요');
      ref
          .read(logProvider.notifier)
          .log('[ProfilePageViewModel]\n\nupdateDisplayName success');
    } catch (e) {
      onError('닉네임 변경 중 오류가 발생했어요\n잠시 후 다시 시도해주세요');
      ref
          .read(logProvider.notifier)
          .log(
            '[ProfilePageViewModel]\n\nupdateDisplayName\n\nerror:\n\n$e',
            type: LogType.error,
          );
    } finally {
      ref.read(globalLoadingProvider.notifier).finish();
    }
  }
}

final profilePageViewModelProvider =
    NotifierProvider<ProfilePageViewModel, void>(ProfilePageViewModel.new);
