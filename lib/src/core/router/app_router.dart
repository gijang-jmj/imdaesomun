import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page.dart';

// GoRouter configuration
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouterPathConstant.home.path,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
