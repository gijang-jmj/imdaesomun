import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [AppBoxShadow.medium],
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppMargin.medium),
                    child: Row(
                      spacing: AppMargin.small,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AppIcon(
                          AppIcons.homeFill,
                          size: AppIconSize.medium,
                          color: AppColors.teal500,
                        ),
                        Expanded(
                          child: Text(
                            TextUtil.keepWord(
                              '최근 10개 공고만 제공되며, 과거 공고 및 검색·정렬 기능은 각 공사의 공식 홈페이지를 이용해주세요',
                            ),
                            style: AppTextStyle.subBody1.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Column(
                  spacing: AppMargin.small,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(
                          AppIcons.sh,
                          size: AppIconSize.extraLarge,
                          special: true,
                        ),
                        const SizedBox(width: AppMargin.extraSmall),
                        Text(
                          '서울주택도시공사',
                          style: AppTextStyle.title1.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        boxShadow: [AppBoxShadow.medium],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppMargin.medium),
                        child: Column(
                          spacing: AppMargin.small,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '2025년 공공임대주택 입주자 모집',
                                  style: AppTextStyle.subTitle2.copyWith(
                                    color: AppColors.gray900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: AppMargin.small,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.date,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '2025.05.01',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.view,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '1,234',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.department,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '서울주택도시공사',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Column(
                  spacing: AppMargin.small,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(
                          AppIcons.gh,
                          size: AppIconSize.extraLarge,
                          special: true,
                        ),
                        const SizedBox(width: AppMargin.extraSmall),
                        Text(
                          '경기주택도시공사',
                          style: AppTextStyle.title1.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        boxShadow: [AppBoxShadow.medium],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppMargin.medium),
                        child: Column(
                          spacing: AppMargin.small,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '2025년 공공임대주택 입주자 모집',
                                  style: AppTextStyle.subTitle2.copyWith(
                                    color: AppColors.gray900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: AppMargin.small,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.date,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '2025.05.01',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.view,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '1,234',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppIcon(
                                      AppIcons.department,
                                      color: AppColors.gray500,
                                    ),
                                    const SizedBox(width: AppMargin.extraSmall),
                                    Text(
                                      '서울주택도시공사',
                                      style: AppTextStyle.subBody3.copyWith(
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppMargin.extraLarge),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.gray100)),
                ),
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
                        TextUtil.keepWord(
                          '임대소문은 서울주택도시공사(SH), 경기주택도시공사(GH)에서 제공하는 공고를 비상업적 목적에 따라 제공하며, 모든 공고의 저작권은 해당 공사에 귀속됩니다. 문의 : wnalsals1127@gmail.com',
                        ),
                        style: AppTextStyle.caption2.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      Text(
                        'Copyright © 2025 Imdaesomun. All rights reserved.',
                        style: AppTextStyle.caption2.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
