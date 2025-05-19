import 'package:flutter/material.dart';

class AppBoxShadow {
  static const BoxShadow medium = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05), // 5% 그림자 색상
    spreadRadius: 0, // 그림자 확산 정도
    blurRadius: 2, // 그림자 흐림 정도
    offset: Offset(0, 1), // 그림자의 위치 (x, y)
  );
}
