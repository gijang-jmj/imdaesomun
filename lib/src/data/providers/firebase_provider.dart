import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseAuthStateChangesProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

final userProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthStateChangesProvider).value;
});

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final firebaseMessageOnTokenRefreshProvider = StreamProvider<String>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  return firebaseMessaging.onTokenRefresh;
});

final fcmTokenProvider = Provider<String?>((ref) {
  final fcmToken = ref.watch(firebaseMessageOnTokenRefreshProvider).value;
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final userId = firebaseAuth.currentUser?.uid;
  if (fcmToken != null) {
    ref
        .read(userRepositoryProvider)
        .registerFcmToken(token: fcmToken, userId: userId);
    ref
        .read(logProvider.notifier)
        .log('[onTokenRefresh]\n\nfcmToken:\n$fcmToken\n\nuserId:\n$userId');
  }
  return fcmToken;
});
