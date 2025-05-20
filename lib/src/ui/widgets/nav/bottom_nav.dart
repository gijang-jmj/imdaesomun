import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class BottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppColors.teal500,
        unselectedItemColor: AppColors.gray400,
        selectedLabelStyle: AppTextStyle.caption1,
        unselectedLabelStyle: AppTextStyle.caption1,
        items: const [
          BottomNavigationBarItem(
            icon: AppIcon(AppIcons.home, size: AppIconSize.large),
            label: '임대소문',
          ),
          BottomNavigationBarItem(
            icon: AppIcon(AppIcons.community, size: AppIconSize.large),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: AppIcon(AppIcons.profile, size: AppIconSize.large),
            label: '내정보',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
