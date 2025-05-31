import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthStateChangesProvider).value;
});

final fcmTokenProvider = Provider<String?>((ref) {
  final fcmToken = ref.watch(firebaseMessageOnTokenRefreshProvider).value;
  final user = ref.watch(userProvider);
  final userId = user?.uid;
  if (fcmToken != null) {
    ref.read(fcmTokenStateProvider.notifier).state = fcmToken;
    ref
        .read(userRepositoryProvider)
        .registerFcmToken(token: fcmToken, userId: userId);
    ref
        .read(logProvider.notifier)
        .log('[onTokenRefresh]\n\nfcmToken:\n$fcmToken\n\nuserId:\n$userId');
  }
  return fcmToken;
});

final fcmTokenStateProvider = StateProvider<String?>((ref) {
  return null;
});
