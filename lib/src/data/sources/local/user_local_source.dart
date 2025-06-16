import 'package:shared_preferences/shared_preferences.dart';

class UserLocalSource {
  static const String _pushAllowedKey = 'push_allowed';

  /// 로컬에서 푸시 알림 허용 여부 가져오기
  Future<bool?> getPushAllowedLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushAllowedKey);
  }

  /// 로컬에 푸시 알림 허용 여부 저장
  Future<void> setPushAllowedLocal({required bool allowed}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushAllowedKey, allowed);
  }

  /// 로컬에서 푸시 알림 설정 삭제
  Future<void> clearPushAllowedLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pushAllowedKey);
  }
}
