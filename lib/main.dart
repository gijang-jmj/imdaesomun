import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/firebase_options.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';
import 'package:imdaesomun/src/core/router/app_router.dart';
import 'package:imdaesomun/src/core/services/permission_service.dart';
import 'package:imdaesomun/src/core/theme/app_theme.dart';
import 'package:imdaesomun/src/data/providers/firebase_provider.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 가져오기
  String env;
  try {
    env = await MethodChannel(
      'com.example.imdaesomun/environment',
    ).invokeMethod('getEnvironment');
  } catch (e) {
    env = 'prod';
  }

  // .env 파일 로드
  if (env == 'local') {
    await dotenv.load(fileName: '.env');
  } else {
    await dotenv.load(fileName: '.env.prod');
  }

  // init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // request push notification permission
  await PermissionService.requestPushPermission();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    initFcmToken(ref);
  }

  @override
  Widget build(BuildContext context) {
    initFcmTokenListener(ref);
    initUserListener(ref);

    return MaterialApp.router(
      title: 'Imdaesomun',
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

/// 최초 FCM 토큰 등록
void initFcmToken(WidgetRef ref) {
  ref
      .read(firebaseMessagingProvider)
      .getToken()
      .then(
        (fcmToken) {
          if (fcmToken != null) {
            ref.read(fcmTokenStateProvider.notifier).state = fcmToken;
          }
        },
        onError: (err) {
          ref
              .read(logProvider.notifier)
              .log('[initFcmToken]\n\nerror:\n$err', type: LogType.error);
        },
      );
}

/// FCM 토큰 갱신 리스너
void initFcmTokenListener(WidgetRef ref) {
  ref.listen(fcmTokenProvider, (previous, fcmToken) {
    if (fcmToken != null) {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;

      ref
          .read(userRepositoryProvider)
          .registerFcmToken(token: fcmToken, userId: userId);
      ref
          .read(logProvider.notifier)
          .log(
            '[initFcmTokenListener]\n\nfcmToken:\n$fcmToken\n\nuserId:\n$userId',
          );
    }
  });
}

/// 유저 갱신 리스너
void initUserListener(WidgetRef ref) {
  ref.listen(userProvider, (previous, user) {
    final fcmToken = ref.read(fcmTokenProvider);

    if (fcmToken != null) {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;

      ref
          .read(userRepositoryProvider)
          .registerFcmToken(token: fcmToken, userId: userId);
      ref
          .read(logProvider.notifier)
          .log(
            '[initUserListener]\n\nfcmToken:\n$fcmToken\n\nuserId:\n$userId',
          );
    }
  });
}
