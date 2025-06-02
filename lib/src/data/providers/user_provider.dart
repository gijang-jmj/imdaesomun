import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthStateChangesProvider).value;
});

final fcmTokenStateProvider = StateProvider<String?>((ref) {
  return null;
});

final fcmTokenProvider = Provider<String?>((ref) {
  final fcmTokenState = ref.watch(fcmTokenStateProvider);
  final fcmTokenRefresh =
      ref.watch(firebaseMessageOnTokenRefreshProvider).value;
  return fcmTokenState ?? fcmTokenRefresh;
});
