import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/notice_card.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});

  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    Throttle.call('saved_page_scroll', const Duration(milliseconds: 200), () {
      if (_isLoadingMore) return;

      // 스크롤이 끝에서 200픽셀 위치에 도달했을 때 더 로드
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    }, trailing: true);
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await ref.read(savedNoticesProvider.notifier).getMoreSavedNotices();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: InformationCard(text: '저장 어쩌구 저쩌구')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppMargin.medium,
                    vertical: AppMargin.small,
                  ),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final savedNotices = ref.watch(savedNoticesProvider);
                      return savedNotices.when(
                        loading:
                            () => Column(
                              spacing: AppMargin.small,
                              children: List.generate(
                                10,
                                (index) => const NoticeCardSkeleton(),
                              ),
                            ),
                        error: (e, st) => Center(child: Text('오류: $e')),
                        data:
                            (page) => Column(
                              spacing: AppMargin.small,
                              children: [
                                ...page.notices.map(
                                  (notice) => NoticeCard(
                                    title: notice.title,
                                    regDate: notice.regDate,
                                    hits: notice.hits,
                                    department: notice.department,
                                    onTap: () {
                                      context.push(
                                        '${RouterPathConstant.notice.path}/${notice.id}',
                                      );
                                    },
                                  ),
                                ),
                                // 더보기 버튼 또는 로딩 인디케이터
                                if (page.hasMore)
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      AppMargin.medium,
                                    ),
                                    child: Center(
                                      child:
                                          _isLoadingMore
                                              ? const CircularProgressIndicator()
                                              : AppTextLineButton(
                                                width: null,
                                                height:
                                                    AppButtonHeight.extraSmall,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: AppMargin.medium,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppRadius.extraLarge,
                                                    ),
                                                onPressed: _loadMore,
                                                text: '더보기',
                                                textStyle:
                                                    AppTextStyle.subBody1,
                                              ),
                                    ),
                                  ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(height: AppMargin.extraLarge),
                    const CopyrightFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
