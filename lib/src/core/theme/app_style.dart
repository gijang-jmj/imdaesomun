import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBoxShadow {
  static const BoxShadow medium = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05), // 5% 그림자 색상
    spreadRadius: 0, // 그림자 확산 정도
    blurRadius: 2, // 그림자 흐림 정도
    offset: Offset(0, 1), // 그림자의 위치 (x, y)
  );

  static const BoxShadow large = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1), // 20% 그림자 색상
    spreadRadius: 0, // 그림자 확산 정도
    blurRadius: 4, // 그림자 흐림 정도
    offset: Offset(0, 1), // 그림자의 위치 (x, y)
  );
}

class AppStatusBarStyle {
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 상태바 배경색
    statusBarIconBrightness: Brightness.dark, // 상태바 아이콘(폰트) 색상
    statusBarBrightness: Brightness.light, // iOS용(다크 아이콘)
  );

  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 상태바 배경색
    statusBarIconBrightness: Brightness.light, // 상태바 아이콘(폰트) 색상
    statusBarBrightness: Brightness.dark, // iOS용(라이트 아이콘)
  );
}
