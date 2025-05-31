import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static String getNickName(User? user) {
    if (user == null) {
      return 'guest';
    }
    if (user.displayName == null || user.displayName!.isEmpty) {
      return '임대소문';
    }
    return user.displayName!;
  }

  static String getUidShort(User? user) {
    if (user == null) {
      return '';
    }
    return '(#${user.uid.substring(user.uid.length - 5)})';
  }
}
