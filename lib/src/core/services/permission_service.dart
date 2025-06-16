import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';

class PermissionService {
  /// iOS APNS 토큰 준비 (권한 요청 없이)
  static Future<void> prepareAPNSToken() async {
    if (!Platform.isIOS) return;

    try {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        LogService.log('[PermissionService]\n\nAPNS token prepared');
      } else {
        LogService.log('[PermissionService]\n\nAPNS token not available yet');
      }
    } catch (e) {
      LogService.log(
        '[PermissionService]\n\nError preparing APNS token',
        error: e.toString(),
      );
    }
  }

  /// 푸시 알림 권한을 요청
  static Future<String?> requestPushPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      if (!isGranted) {
        LogService.log(
          '[PermissionService]\n\nPush notification permission denied\n\nAuthorizationStatus:\n${settings.authorizationStatus}',
          type: LogType.warning,
        );
        return null;
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        LogService.log(
          '[PermissionService]\n\nFCM token is null',
          type: LogType.warning,
        );
        return null;
      } else {
        LogService.log(
          '[PermissionService]\n\nFCM token:\n$fcmToken',
          type: LogType.info,
        );
        return fcmToken;
      }
    } catch (e) {
      LogService.log(
        '[PermissionService]\n\nError requesting push notification permission',
        error: e.toString(),
        type: LogType.error,
      );
      return null;
    }
  }

  /// 푸시 알림 권한 상태 확인
  static Future<AuthorizationStatus> getPushStatus() async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      return settings.authorizationStatus;
    } catch (e) {
      LogService.log(
        '[PermissionService]\n\nError checking push notification permission: $e',
        type: LogType.error,
      );
      return AuthorizationStatus.denied;
    }
  }
}
