import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/gh_section.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/sh_section.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page_view_model.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    // 앱 시작 시 메시지 등록
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        if (mounted && message.data['noticeId'] != null) {
          context.push(
            '${RouterPathConstant.notice.path}/${message.data['noticeId']}',
          );
        }
        ref
            .read(logProvider.notifier)
            .log('[getInitialMessage]\n\nmessage:\n${message.data}');
      }
    });

    // 백그라운드 메시지 리스너 등록
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (mounted && message.data['noticeId'] != null) {
        context.push(
          '${RouterPathConstant.notice.path}/${message.data['noticeId']}',
        );
      }
      ref.read(shNoticesProvider.notifier).getNotices(throttle: false);
      ref.read(ghNoticesProvider.notifier).getNotices(throttle: false);
      ref
          .read(logProvider.notifier)
          .log('[onMessageOpenedApp]\n\nmessage:\n${message.data}');
    });

    // 포그라운드 메시지 리스너 등록
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ref.read(shNoticesProvider.notifier).getNotices(throttle: false);
      ref.read(ghNoticesProvider.notifier).getNotices(throttle: false);
      ref
          .read(logProvider.notifier)
          .log('[onMessage]\n\nmessage:\n${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReorderMode = ref.watch(reorderModeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(shNoticesProvider.notifier).getNotices();
              ref.read(ghNoticesProvider.notifier).getNotices();
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                InformationCard(
                  text:
                      '최근 10개 공고만 제공되며, 과거 공고 및 검색·정렬 기능은 각 공사의 공식 홈페이지를 이용해주세요',
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  children:
                      [CorporationType.sh, CorporationType.gh]
                          .map(
                            (corporationType) =>
                                _getNoticeSection(corporationType),
                          )
                          .toList(),
                  onReorder: (oldIndex, newIndex) {
                    // ref
                    //     .read(bannerOrderProvider.notifier)
                    //     .reorderBanners(oldIndex, newIndex);
                    ref.read(reorderModeProvider.notifier).state = false;
                  },
                ),
                const SizedBox(height: AppMargin.extraLarge),
                if (!isReorderMode) const CopyrightFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _getNoticeSection(CorporationType corporationType) {
  if (corporationType == CorporationType.sh) {
    return ShSection(key: ValueKey(corporationType));
  } else {
    return GhSection(key: ValueKey(corporationType));
  }
}
