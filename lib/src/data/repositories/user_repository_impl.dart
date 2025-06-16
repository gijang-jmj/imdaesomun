import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/providers/dio_provider.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';
import 'package:imdaesomun/src/data/sources/local/user_local_source.dart';
import 'package:imdaesomun/src/data/sources/remote/user_source.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return UserRepositoryImpl(
    userSource: UserSource(dio, firebaseAuth),
    userLocalSource: UserLocalSource(),
  );
});

class UserRepositoryImpl implements UserRepository {
  final UserSource _userSource;
  final UserLocalSource _userLocalSource;

  const UserRepositoryImpl({
    required UserSource userSource,
    required UserLocalSource userLocalSource,
  }) : _userSource = userSource,
       _userLocalSource = userLocalSource;

  @override
  Future<void> registerFcmToken({
    required String token,
    String? userId,
    bool? allowed,
  }) async {
    final allowed = await _userLocalSource.getPushAllowedLocal();
    await _userSource.registerFcmToken(
      token: token,
      userId: userId,
      allowed: allowed,
    );
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
  Future<void> deleteUser({required String password}) async {
    await _userSource.deleteUser(password: password);
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
  Future<void> reloadUser() async {
    await _userSource.reloadUser();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _userSource.resetPassword(email: email);
  }

  @override
  Future<bool> getPushAllowed({required String token}) async {
    final localPushAllowed = await _userLocalSource.getPushAllowedLocal();

    if (localPushAllowed != null) {
      return localPushAllowed;
    }

    final remotePushAllowed = await _userSource.getPushAllowed(token: token);
    await _userLocalSource.setPushAllowedLocal(allowed: remotePushAllowed);

    return remotePushAllowed;
  }

  @override
  Future<void> setPushAllowed({
    required String token,
    required bool allowed,
  }) async {
    await _userSource.setPushAllowed(token: token, allowed: allowed);
    await _userLocalSource.setPushAllowedLocal(allowed: allowed);
  }
}
