import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';

class PermissionService {
  /// 푸시 알림 권한을 요청
  static Future<bool> requestPushPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      if (!isGranted) {
        LogService.log(
          '[PermissionService]\n\nPush notification permission denied\n\nAuthorizationStatus:\n${settings.authorizationStatus}',
          type: LogType.warning,
        );
        return false;
      }

      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          LogService.log(
            '[PermissionService]\n\nAPNs token is null',
            type: LogType.warning,
          );
          return false;
        }
      }

      LogService.log(
        '[PermissionService]\n\nPush notification permission granted',
        type: LogType.info,
      );
      return true;
    } catch (e) {
      LogService.log(
        '[PermissionService]\n\nError requesting push notification permission: $e',
        type: LogType.error,
      );
      return false;
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
