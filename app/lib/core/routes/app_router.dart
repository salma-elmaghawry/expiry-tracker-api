import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/widgets/main_shell.dart';
import 'package:expiry_tracker/core/widgets/not_found_screen.dart';
import 'package:expiry_tracker/features/add_batch/presentation/screens/add_batch_screen.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:expiry_tracker/features/batches/presentation/screens/batches_screen.dart';
import 'package:expiry_tracker/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:expiry_tracker/features/reports/presentation/screens/reports_screen.dart';
import 'package:expiry_tracker/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:expiry_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:expiry_tracker/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter config = GoRouter(
    initialLocation: Routes.splash,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(path: Routes.root, redirect: (context, state) => Routes.splash),
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Outside the shell, so the camera covers the whole screen (no bottom bar).
      GoRoute(
        path: Routes.scan,
        builder: (context, state) => const ScannerScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.batches,
                builder: (context, state) {
                  final query = state.uri.queryParameters;
                  return BatchesScreen(
                    filters: BatchFilters(
                      status: tryEnumFromApi(
                        BatchStatus.values,
                        query[Routes.statusParam],
                      ),
                      urgency: tryEnumFromApi(
                        ExpiryBucket.values,
                        query[Routes.urgencyParam],
                      ),
                      fromDashboard:
                          query[Routes.fromParam] == Routes.fromDashboard,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const AddBatchScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reports,
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
