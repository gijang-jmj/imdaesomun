import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/ui/components/loading/global_loading.dart';
import 'package:imdaesomun/src/ui/components/toast/global_toast.dart';
import 'package:imdaesomun/src/ui/pages/community/community_page.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page.dart';
import 'package:imdaesomun/src/ui/pages/log/log_page.dart';
import 'package:imdaesomun/src/ui/pages/profile/profile_page.dart';
import 'package:imdaesomun/src/ui/pages/webview/gh_document_viewer.dart';
import 'package:imdaesomun/src/ui/pages/webview/sh_document_viewer.dart';
import 'package:imdaesomun/src/ui/pages/webview/test.dart';
import 'package:imdaesomun/src/ui/widgets/dev_tools/dev_tools_overlay.dart';
import 'package:imdaesomun/src/ui/widgets/nav/bottom_nav.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: RouterPathConstant.home.path,
  routes: [
    // Dev Tools (Debug only)
    ShellRoute(
      builder: (context, state, child) {
        return DevToolsOverlay(child: child);
      },
      routes: [
        // Global Loading
        ShellRoute(
          builder: (context, state, child) {
            return GlobalLoading(child: child);
          },
          routes: [
            // Global Toast
            ShellRoute(
              builder: (context, state, child) {
                return GlobalToast(child: child);
              },
              // Main Pages
              routes: [
                StatefulShellRoute.indexedStack(
                  builder:
                      (context, state, navigationShell) =>
                          BottomNav(navigationShell: navigationShell),
                  branches: [
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: RouterPathConstant.home.path,
                          builder: (context, state) => const HomePage(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: RouterPathConstant.community.path,
                          builder: (context, state) => const CommunityPage(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: RouterPathConstant.profile.path,
                          builder: (context, state) => const ProfilePage(),
                        ),
                      ],
                    ),
                  ],
                ),
                // 로그
                GoRoute(
                  path: RouterPathConstant.log.path,
                  builder: (context, state) => const LogPage(),
                ),
                // GH 문서 뷰어
                GoRoute(
                  path: RouterPathConstant.ghViewer.path,
                  builder:
                      (context, state) => GhDocumentViewer(attachNo: '79544'),
                ),
                // SH 문서 뷰어
                GoRoute(
                  path: RouterPathConstant.shViewer.path,
                  builder:
                      (context, state) => ShDocumentViewer(
                        url:
                            'https://www.i-sh.co.kr/main/com/util/htmlConverter.do?brd_id=GS0401&seq=288587&data_tp=A&file_seq=4',
                      ),
                ),
                // test
                GoRoute(
                  path: '/test',
                  builder: (context, state) => const HtmlViewPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
