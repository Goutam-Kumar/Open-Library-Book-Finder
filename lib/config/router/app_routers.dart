import 'package:book_finder/config/router/app_routes.dart';
import 'package:book_finder/presentation/page/book_details.dart';
import 'package:book_finder/presentation/page/landing_page.dart';
import 'package:go_router/go_router.dart';

GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.landingPagePath,
    routes: [
      GoRoute(
          path: AppRoutes.landingPagePath,
          builder: (context, state) => const LandingPage()
      ),
      GoRoute(
          path: AppRoutes.bookDetailsPagePath,
          builder: (context, state) {
            final selectedBook = state.extra as Map<String,dynamic>;
            return BookDetails(selectedBook: selectedBook);
          }
      )
    ]
);