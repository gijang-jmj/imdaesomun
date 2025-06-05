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
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_card.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';
import 'package:imdaesomun/src/ui/widgets/card/login_card.dart';
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
    ref.listen(userProvider, (previous, next) {
      ref.read(savedNoticesProvider.notifier).refreshSavedNotices();
    });

    final user = ref.watch(userProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (user == null) ...[
                SliverToBoxAdapter(
                  child: const InformationCard(
                    text: '로그인하면 관심 있는 공고를 언제든 저장하고 공유할 수 있어요',
                  ),
                ),
                SliverToBoxAdapter(
                  child: const LoginCard(
                    description: '비회원이신가요?\n이메일로 간단하게 가입할 수 있어요',
                  ),
                ),
              ],
              if (user != null) ...[
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
                                    (notice) => SavedCard(
                                      title: notice.title,
                                      regDate: notice.regDate,
                                      hits: notice.hits,
                                      department: notice.department,
                                      corporation: notice.corporation,
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
                                                      AppButtonHeight
                                                          .extraSmall,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        AppMargin.medium,
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
            ],
          ),
        ),
      ),
    );
  }
}
