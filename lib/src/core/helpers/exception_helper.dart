import 'package:firebase_auth/firebase_auth.dart';

class ExceptionHelper {
  static String? getFirebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return '입력한 정보가 올바르지 않아요';
      case 'user-not-found':
        return '존재하지 않는 계정이에요';
      case 'wrong-password':
        return '일치하지 않은 비밀번호에요';
      case 'too-many-requests':
        return '너무 많은 요청이 들어왔어요\n잠시 후 다시 시도해주세요';
      case 'invalid-email':
        return '유효하지 않은 이메일 형식이에요';
      case 'no-user':
        return '로그인된 유저가 없어요\n다시 로그인해주세요';
      case 'weak-password':
        return '6자리 이상의 비밀번호를 입력해주세요';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일이에요';
      case 'email-already-verified':
        return '이미 인증된 이메일이에요';
      case 'user-mismatch':
        return '사용자 정보가 일치하지 않아요';
      case 'invalid-verification-code':
        return '인증 코드가 올바르지 않아요';
      case 'invalid-verification-id':
        return '인증 ID가 올바르지 않아요';
      default:
        return null;
    }
  }
}
