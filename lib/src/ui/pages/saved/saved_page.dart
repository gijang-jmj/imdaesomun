import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_footer.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_header.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_section.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_top.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';
import 'package:imdaesomun/src/ui/widgets/card/login_card.dart';

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
    ref.listen(userProvider, (previous, user) {
      ref
          .read(savedNoticesProvider.notifier)
          .refreshSavedNotices(userId: user?.uid);
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
                  child: const InformationCard(text: '관심 있는 공고를 언제든 저장할 수 있어요'),
                ),
                SliverToBoxAdapter(
                  child: const LoginCard(
                    description: '비회원이신가요?\n이메일로 간단하게 가입할 수 있어요',
                  ),
                ),
              ],
              if (user != null) ...[
                SliverToBoxAdapter(child: SavedTop()),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 48,
                    maxHeight: 48,
                    child: SavedHeader(
                      scrollToTop: () {
                        _scrollController.jumpTo(0);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SavedSection(
                    isLoadingMore: _isLoadingMore,
                    onPressed: _loadMore,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: const SavedFooter(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: shrinkOffset > 0 ? Colors.white : Colors.transparent,
      child: SizedBox.expand(child: child),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
