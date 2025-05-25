import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/firebase_options.dart';
import 'package:imdaesomun/src/core/router/app_router.dart';
import 'package:imdaesomun/src/core/theme/app_theme.dart';

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

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
