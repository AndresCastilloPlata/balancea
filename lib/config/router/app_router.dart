import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';
import 'package:balancea/presentation/widgets/shared/main_bottom_nav.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainBottomNav(navigationShell: navigationShell),
      branches: [
        // Home:0
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: CurveTween(
                          curve: Curves.easeInOut,
                        ).animate(animation),
                        child: child,
                      );
                    },
              ),
            ),
          ],
        ),
        // Stats:1
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),

        //Transactions:2
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),

        // Settings:3
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);
