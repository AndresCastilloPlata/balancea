import 'package:balancea/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';
import 'package:balancea/presentation/widgets/shared/main_bottom_nav.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: null,
    routes: [
      // Pantalla de Bloqueo Biométrico
      GoRoute(
        path: '/auth',
        builder: (context, state) => const BiometricAuthScreen(),
      ),

      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Barra de navegacion (ShellRoute)
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
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const SplashScreen(),
      // ),
    ],

    // Guardia de seguridad
    redirect: (context, state) {
      final isGoingToAuth = state.matchedLocation == '/auth';
      final isBiometricEnabled = settings.isBiometricEnabled;

      if (isBiometricEnabled && !isGoingToAuth) {
        return null;
      }
      return null;
    },
  );
});
