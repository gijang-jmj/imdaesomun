import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppMargin.large,
          horizontal: AppMargin.medium,
        ),
        child: Column(
          spacing: AppMargin.mediumLarge,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '임대소문은 서울주택도시공사(SH), 경기주택도시공사(GH), 인천도시공사(IH), 부산도시공사(BMC)에서 제공하는 공고를 비상업적 목적에 따라 제공하며, 모든 공고의 저작권은 해당 공사에 귀속됩니다. 문의 : wnalsals1127@gmail.com',
              style: AppTextStyle.caption2.copyWith(color: AppColors.gray500),
            ),
            Text(
              'Copyright © 2025 Imdaesomun. All rights reserved.',
              style: AppTextStyle.caption2.copyWith(color: AppColors.gray400),
            ),
          ],
        ),
      ),
    );
  }
}
