import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/data/models/file.dart';
import 'package:imdaesomun/src/ui/widgets/loading/global_loading.dart';
import 'package:imdaesomun/src/ui/pages/dialog/dialog_page.dart';
import 'package:imdaesomun/src/ui/widgets/toast/global_toast.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page.dart';
import 'package:imdaesomun/src/ui/pages/log/log_page.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page.dart';
import 'package:imdaesomun/src/ui/pages/profile/profile_page.dart';
import 'package:imdaesomun/src/ui/pages/webview/document_viewer.dart';
import 'package:imdaesomun/src/ui/widgets/dev_tools/dev_tools_overlay.dart';
import 'package:imdaesomun/src/ui/widgets/dialog/error_dialog.dart';
import 'package:imdaesomun/src/ui/widgets/nav/bottom_nav.dart';
import 'package:imdaesomun/src/core/providers/navigation_provider.dart';

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
                          NavigationShellProvider(
                            navigationShell: navigationShell,
                            child: BottomNav(navigationShell: navigationShell),
                          ),
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
                          path: RouterPathConstant.saved.path,
                          builder: (context, state) => const SavedPage(),
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
                // 문서 뷰어
                GoRoute(
                  path: RouterPathConstant.documentViewer.path,
                  builder:
                      (context, state) =>
                          DocumentViewer(file: state.extra as File),
                ),
                // 임대공고 상세 페이지
                GoRoute(
                  path: '${RouterPathConstant.notice.path}/:id',
                  builder:
                      (context, state) =>
                          NoticePage(id: state.pathParameters['id']!),
                ),
                // Custom Dialog
                GoRoute(
                  path: RouterPathConstant.dialog.path,
                  pageBuilder: (context, state) {
                    final dialog = state.extra as Widget?;
                    return CustomTransitionPage(
                      opaque: false,
                      child: DialogPage(dialog: dialog ?? const ErrorDialog()),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        );
                        return ScaleTransition(
                          scale: Tween<double>(
                            begin: 1.08,
                            end: 1.0,
                          ).animate(curved),
                          child: FadeTransition(
                            opacity: Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(curved),
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
