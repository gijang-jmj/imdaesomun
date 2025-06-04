import 'package:flutter/cupertino.dart';

class AppBarHeight {
  /// 40
  static const double small = 40.0;

  /// 48
  static const double medium = 48.0;

  /// 56
  static const double large = 56.0;
}

class AppButtonHeight {
  /// 32
  static const double extraSmall = 32.0;

  /// 40
  static const double small = 40.0;

  /// 48
  static const double medium = 48.0;

  /// 56
  static const double large = 56.0;

  /// 64
  static const double extraLarge = 64.0;
}

class AppMargin {
  /// 4
  static const double extraSmall = 4.0;

  /// 8
  static const double small = 8.0;

  /// 12
  static const double smallMedium = 12.0;

  /// 16
  static const double medium = 16.0;

  /// 20
  static const double mediumLarge = 20.0;

  /// 24
  static const double large = 24.0;

  /// 32
  static const double extraLarge = 32.0;
}

class AppRadius {
  /// 10
  static const double small = 10.0;

  /// 12
  static const double medium = 12.0;

  /// 14
  static const double mediumLarge = 14.0;

  /// 16
  static const double large = 16.0;

  /// 100
  static const double extraLarge = 100.0;
}

class AppEdgeInsets {
  /// 바텀 버튼의 바깥 여백
  static const bottomButtonMargin = EdgeInsets.only(
    left: AppMargin.medium,
    right: AppMargin.medium,
    top: AppMargin.extraSmall,
    bottom: AppMargin.smallMedium,
  );

  /// 바텀 버튼의 안쪽 여백
  static const bottomButtonPadding = EdgeInsets.symmetric(
    horizontal: AppMargin.large,
  );
}

class AppIconSize {
  /// 14
  static const double small = 14.0;

  /// 18
  static const double medium = 18.0;

  /// 22
  static const double large = 22.0;

  /// 24
  static const double extraLarge = 24.0;
}
