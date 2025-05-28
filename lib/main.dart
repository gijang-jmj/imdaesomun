import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/firebase_options.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/router/app_router.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/services/permission_service.dart';
import 'package:imdaesomun/src/core/theme/app_theme.dart';
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

    // 최초 토큰 등록
    FirebaseMessaging.instance.getToken().then(
      (fcmToken) {
        if (fcmToken != null) {
          ref.read(userRepositoryProvider).registerFcmToken(token: fcmToken);
          ref
              .read(logProvider.notifier)
              .log('[getToken]\n\nfcmToken:\n$fcmToken');
        }
      },
      onError: (err) {
        ref
            .read(logProvider.notifier)
            .log('[getToken]\n\nerror:\n$err', type: LogType.error);
      },
    );

    // 토큰 갱신 리스너 등록
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          ref.read(userRepositoryProvider).registerFcmToken(token: fcmToken);
          ref
              .read(logProvider.notifier)
              .log('[onTokenRefresh]\n\nfcmToken:\n$fcmToken');
        })
        .onError((err) {
          ref
              .read(logProvider.notifier)
              .log('[onTokenRefresh]\n\nerror:\n$err', type: LogType.error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Imdaesomun',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
