import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/bmc_section.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/gh_section.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/ih_section.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/sh_section.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_button_card.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page_view_model.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> setupInteractedMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);

      ref
          .read(logProvider.notifier)
          .log('[getInitialMessage]\n\nmessage:\n${initialMessage.data}');
    }

    // 백그라운드 메시지 리스너 등록
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 중복 처리를 방지하기 위해 메시지 ID를 비교
      if (message.messageId != initialMessage?.messageId) {
        _handleMessage(message);
      }

      ref.read(homePageViewModelProvider.notifier).forceRefresh();
      ref
          .read(logProvider.notifier)
          .log('[onMessageOpenedApp]\n\nmessage:\n${message.data}');
    });

    // 포그라운드 메시지 리스너 등록
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ref.read(homePageViewModelProvider.notifier).forceRefresh();
      ref
          .read(logProvider.notifier)
          .log('[onMessage]\n\nmessage:\n${message.data}');
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (mounted && message.data['noticeId'] != null) {
      context.push(
        '${RouterPathConstant.notice.path}/${message.data['noticeId']}',
      );
    }
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    final isReorderMode = ref.watch(reorderModeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: Column(
            children: [
              // 메인 콘텐츠 영역
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.read(shNoticesProvider.notifier).getNotices();
                    ref.read(ghNoticesProvider.notifier).getNotices();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 상단 정보 카드
                        if (!isReorderMode)
                          InformationCard(
                            text:
                                '최근 10개 공고만 제공되며, 과거 공고 및 검색·정렬 기능은 각 공사의 공식 홈페이지를 이용해주세요',
                          ),
                        if (isReorderMode)
                          InformationCard(text: '항목을 드래그해서 순서를 변경할 수 있어요'),
                        // 공고 섹션
                        Consumer(
                          builder: (context, ref, child) {
                            final noticeOrder = ref.watch(
                              noticeOrderListProvider,
                            );

                            return noticeOrder.when(
                              data:
                                  (list) => ReorderableListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    buildDefaultDragHandles: false,
                                    children: [
                                      for (
                                        int index = 0;
                                        index < list.length;
                                        index += 1
                                      )
                                        _getNoticeSection(
                                          corporationType: list[index],
                                          index: index,
                                        ),
                                    ],
                                    onReorder: (oldIndex, newIndex) {
                                      ref
                                          .read(
                                            noticeOrderListProvider.notifier,
                                          )
                                          .updateOrder(
                                            oldIndex: oldIndex,
                                            newIndex: newIndex,
                                          );
                                    },
                                  ),
                              error: (e, st) => Center(child: Text('오류: $e')),
                              loading:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );
                          },
                        ),
                        const SizedBox(height: AppMargin.extraLarge),
                        // 저작권 푸터
                        if (!isReorderMode) const CopyrightFooter(),
                      ],
                    ),
                  ),
                ),
              ),
              // 순서 변경 모드 안내 카드
              if (isReorderMode)
                InformationButtonCard(
                  text: '순서 변경을 완료하려면 저장을 눌러주세요',
                  leftText: '저장',
                  rightText: '취소',
                  icon: AppIcons.info,
                  onLeft: () {
                    ref.read(noticeOrderListProvider.notifier).saveOrder();
                    ref.read(reorderModeProvider.notifier).state = false;
                  },
                  onRight: () {
                    ref.read(noticeOrderListProvider.notifier).cancelOrder();
                    ref.read(reorderModeProvider.notifier).state = false;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getNoticeSection({
  required CorporationType corporationType,
  required int index,
}) {
  if (corporationType == CorporationType.sh) {
    return ShSection(key: ValueKey(corporationType), index: index);
  } else if (corporationType == CorporationType.gh) {
    return GhSection(key: ValueKey(corporationType), index: index);
  } else if (corporationType == CorporationType.ih) {
    return IhSection(key: ValueKey(corporationType), index: index);
  } else {
    return BmcSection(key: ValueKey(corporationType), index: index);
  }
}
