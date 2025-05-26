import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionService {
  /// 푸시 알림 권한이 있는지 확인
  static Future<bool> hasPushPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    final isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!isGranted) {
      print('Notification permission denied');
      return false;
    }

    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        print('APNs token is null');
        return false;
      }
    }

    return true;
  }
}
