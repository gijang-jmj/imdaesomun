import 'package:flutter/material.dart';
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
    );
  }
}
