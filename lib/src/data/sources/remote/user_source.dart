import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSource {
  final Dio _dio;
  final FirebaseAuth _firebaseAuth;

  const UserSource(this._dio, this._firebaseAuth);

  /// FCM 토큰 등록
  Future<void> registerFcmToken({required String token, String? userId}) async {
    await _dio.post(
      '/registerFcmToken',
      data: {'token': token, 'userId': userId},
    );
  }

  /// 회원가입 (create user with email and password)
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그인 (sign in with email and password)
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그아웃 (sign out)
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// 회원탈퇴 (delete user)
  Future<void> deleteUser({required String password}) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    // Re-authenticate the user with the provided password
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
  }

  /// 사용자에게 인증 메일 보내기 (send email verification)
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    if (user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email is already verified.',
      );
    }

    await user.sendEmailVerification();
  }

  /// 비밀번호 재설정 이메일 보내기 (send password reset email)
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// 닉네임 변경 (update user display name)
  Future<void> updateUserDisplayName({required String displayName}) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    await user.updateProfile(displayName: displayName);
  }

  /// 유저 리로드
  Future<void> reloadUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    await user.reload();
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// 푸시 알림 허용 여부 확인
  Future<bool> getPushAllowed({required String token}) async {
    final response = await _dio.post('/getPushAllowed', data: {'token': token});

    return response.data['allowed'] as bool;
  }

  /// 푸시 알림 허용 여부 설정
  Future<void> setPushAllowed({
    required String token,
    required bool allowed,
  }) async {
    await _dio.post(
      '/setPushAllowed',
      data: {'token': token, 'allowed': allowed},
    );
  }
}
