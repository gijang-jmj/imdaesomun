import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionService {
  /// 푸시 알림 권한을 요청
  static Future<void> requestPushPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    final isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!isGranted) {
      print('Notification permission denied');
      return;
    }

    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        print('APNs token is null');
      }
    }
  }
}
