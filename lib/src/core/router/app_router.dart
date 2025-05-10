import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page.dart';

// GoRouter configuration
final appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
);
