import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/helpers/notice_helper.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/format_util.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';
import 'package:shimmer/shimmer.dart';

class NoticeDetailCard extends StatefulWidget {
  final Notice notice;

  const NoticeDetailCard({super.key, required this.notice});

  @override
  State<NoticeDetailCard> createState() => _NoticeDetailCardState();
}

class _NoticeDetailCardState extends State<NoticeDetailCard> {
  bool showAllFiles = false;

  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppBoxShadow.medium],
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppMargin.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppMargin.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NoticeHelper.getCorporationType(notice.corporation).korean,
                    style: AppTextStyle.subBody1.copyWith(
                      color: AppColors.teal500,
                    ),
                  ),
                  Text(
                    notice.title,
                    style: AppTextStyle.subTitle1.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: AppMargin.small),
                  Wrap(
                    spacing: AppMargin.small,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppIcon(AppIcons.date, color: AppColors.gray500),
                          const SizedBox(width: AppMargin.extraSmall),
                          Text(
                            FormatUtil.formatDate(notice.regDate),
                            style: AppTextStyle.subBody3.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppIcon(AppIcons.view, color: AppColors.gray500),
                          const SizedBox(width: AppMargin.extraSmall),
                          Text(
                            FormatUtil.formatNumberWithComma(notice.hits),
                            style: AppTextStyle.subBody3.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppIcon(
                            AppIcons.department,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(width: AppMargin.extraSmall),
                          Text(
                            notice.department,
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
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppMargin.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: AppMargin.extraSmall,
                    children: [
                      Text(
                        '첨부파일',
                        style: AppTextStyle.subBody1.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      Text(
                        '* 미리보기만 제공해요',
                        style: AppTextStyle.caption2.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppMargin.medium),
                  notice.files.isNotEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppMargin.medium,
                        children: [
                          ...(showAllFiles
                                  ? notice.files
                                  : notice.files.take(2))
                              .map((file) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      RouterPathConstant.documentViewer.path,
                                      extra: file,
                                    );
                                  },
                                  child: Text(
                                    file.fileName,
                                    style: AppTextStyle.body2.copyWith(
                                      color: AppColors.teal500,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.teal500,
                                      decorationThickness: 0.5,
                                    ),
                                  ),
                                );
                              }),
                          if (notice.files.length > 2)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAllFiles = !showAllFiles;
                                });
                              },
                              child: Text(
                                showAllFiles
                                    ? '첨부파일 접기'
                                    : '첨부파일 더보기(${notice.files.length - 2})',
                                style: AppTextStyle.subBody3.copyWith(
                                  color: AppColors.teal500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      )
                      : Text(
                        '첨부파일 없음',
                        style: AppTextStyle.subBody3.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppMargin.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppMargin.extraLarge,
                children: [
                  ...notice.contents.map((content) {
                    return Text(
                      content,
                      style: AppTextStyle.body2.copyWith(
                        color: AppColors.gray900,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }
}

class NoticeDetailCardSkeleton extends StatelessWidget {
  const NoticeDetailCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppBoxShadow.medium],
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppMargin.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 부제목, 제목
            Shimmer.fromColors(
              baseColor: AppColors.gray100,
              highlightColor: AppColors.gray200,
              child: Container(
                height: 18,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Shimmer.fromColors(
              baseColor: AppColors.gray100,
              highlightColor: AppColors.gray200,
              child: Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: AppMargin.small),
            // 날짜/조회수/부서
            Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(right: AppMargin.small),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.gray100,
                    highlightColor: AppColors.gray200,
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppMargin.medium),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppMargin.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.gray100,
                    highlightColor: AppColors.gray200,
                    child: Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppMargin.medium),
                  Row(
                    children: List.generate(
                      2,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: AppMargin.small),
                        child: Shimmer.fromColors(
                          baseColor: AppColors.gray100,
                          highlightColor: AppColors.gray200,
                          child: Container(
                            height: 20,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppColors.gray100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppMargin.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppMargin.small),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.gray100,
                      highlightColor: AppColors.gray200,
                      child: Container(
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.gray100,
            ),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }
}
