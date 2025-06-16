import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<void> registerFcmToken({
    required String token,
    String? userId,
    bool? allowed,
  });
  Future<UserCredential> signUp({
    required String email,
    required String password,
  });
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> deleteUser({required String password});
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> updateUserDisplayName({required String displayName});
  Future<void> reloadUser();
  Future<void> resetPassword({required String email});
  Future<bool> getPushAllowed({required String token});
  Future<void> setPushAllowed({required String token, required bool allowed});
}
