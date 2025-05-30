import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/dio_service.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/sources/remote/user_source.dart';

abstract class UserRepository {
  Future<void> registerFcmToken({required String token, String? userId});
  Future<UserCredential> signUp({
    required String email,
    required String password,
  });
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> deleteUser();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> updateUserDisplayName({required String displayName});
  Future<User> reloadUser();
}

class UserRepositoryImpl implements UserRepository {
  final UserSource _userSource;

  const UserRepositoryImpl({required UserSource userSource})
    : _userSource = userSource;

  @override
  Future<void> registerFcmToken({required String token, String? userId}) async {
    await _userSource.registerFcmToken(token: token, userId: userId);
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _userSource.signUp(email: email, password: password);
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _userSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _userSource.signOut();
  }

  @override
  Future<void> deleteUser() async {
    await _userSource.deleteUser();
  }

  @override
  Future<void> sendEmailVerification() async {
    await _userSource.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _userSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateUserDisplayName({required String displayName}) async {
    await _userSource.updateUserDisplayName(displayName: displayName);
  }

  @override
  Future<User> reloadUser() async {
    return await _userSource.reloadUser();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return UserRepositoryImpl(userSource: UserSource(dio, firebaseAuth));
});
