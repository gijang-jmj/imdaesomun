import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';

class AppTheme {
  // Light theme
  static ThemeData get light {
    return ThemeData(
      fontFamily: 'Pretendard',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal500,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light, // iOS
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData get dark {
    return ThemeData(
      fontFamily: 'Pretendard',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal500,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light, // iOS
        ),
      ),
    );
  }
}
