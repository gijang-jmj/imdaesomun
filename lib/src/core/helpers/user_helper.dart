import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static String generateUserName(User? user) {
    if (user == null) {
      return 'guest';
    }
    if (user.displayName == null || user.displayName!.isEmpty) {
      return '임대소문(#${user.uid.substring(user.uid.length - 4)})';
    }
    return user.displayName!;
  }
}
