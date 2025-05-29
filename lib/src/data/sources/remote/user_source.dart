import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSource {
  final Dio _dio;

  const UserSource(this._dio);

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
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그인 (sign in with email and password)
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그아웃 (sign out)
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// 회원탈퇴 (delete user)
  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// 사용자에게 인증 메일 보내기 (send email verification)
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// 비밀번호 재설정 이메일 보내기 (send password reset email)
  Future<void> sendPasswordResetEmail({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  /// 닉네임 변경 (update user display name)
  Future<void> updateUserDisplayName({required String displayName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: displayName);
      await user.reload();
    }
  }
}
