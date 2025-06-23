import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';

class AppIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;
  final BlendMode? blendMode;

  /// 특수 아이콘 여부
  /// ex) GH, SH 아이콘
  final bool? special;

  const AppIcon(
    this.assetPath, {
    super.key,
    this.size = AppIconSize.small,
    this.color,
    this.blendMode = BlendMode.srcIn,
    this.special = false,
  });

  @override
  Widget build(BuildContext context) {
    // 상위 위젯에서 IconThemeData를 사용하여 색상을 설정한 경우 대응(ex. NavigationBar)
    final iconColor = color ?? IconTheme.of(context).color;

    return SvgPicture.asset(
      assetPath,
      height: size,
      colorFilter:
          special! || iconColor == null
              ? null
              : ColorFilter.mode(iconColor, blendMode!),
    );
  }
}

class AppIcons {
  // default
  static const String _iconPath = 'assets/icons';
  static const String ai = '$_iconPath/ai.svg';
  static const String arrow = '$_iconPath/arrow.svg';
  static const String back = '$_iconPath/back.svg';
  static const String bell = '$_iconPath/bell.svg';
  static const String bookmarkCheck = '$_iconPath/bookmark_check.svg';
  static const String bookmark = '$_iconPath/bookmark.svg';
  static const String change = '$_iconPath/change.svg';
  static const String comment = '$_iconPath/comment.svg';
  static const String community = '$_iconPath/community.svg';
  static const String date = '$_iconPath/date.svg';
  static const String delete = '$_iconPath/delete.svg';
  static const String department = '$_iconPath/department.svg';
  static const String edit = '$_iconPath/edit.svg';
  static const String error = '$_iconPath/error.svg';
  static const String homeFill = '$_iconPath/home_fill.svg';
  static const String home = '$_iconPath/home.svg';
  static const String info = '$_iconPath/info.svg';
  static const String link = '$_iconPath/link.svg';
  static const String mail = '$_iconPath/mail.svg';
  static const String order = '$_iconPath/order.svg';
  static const String out = '$_iconPath/out.svg';
  static const String post = '$_iconPath/post.svg';
  static const String profile = '$_iconPath/profile.svg';
  static const String view = '$_iconPath/view.svg';
  static const String viewOff = '$_iconPath/view_off.svg';

  // special
  static const String sh = '$_iconPath/sh.svg';
  static const String gh = '$_iconPath/gh.svg';
}
