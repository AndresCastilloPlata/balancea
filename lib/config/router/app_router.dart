import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';
import 'package:balancea/presentation/widgets/shared/main_bottom_nav.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: null,
    routes: [
      // Pantalla de Bloqueo Biométrico
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const BiometricAuthScreen(),
      ),
      GoRoute(
        path: '/pin',
        builder: (context, state) {
          // Recibimos el parámetro: ¿Es modo creación?
          // Por defecto false (Modo Ingreso) si no se especifica.
          final bool isCreation = state.extra as bool? ?? false;
          return PinScreen(isCreationMode: isCreation);
        },
      ),
      GoRoute(
        path: '/create-category',
        builder: (context, state) {
          final bool isExpense = state.extra as bool? ?? true;
          return CreateCategoryScreen(isExpense: isExpense);
        },
      ),

      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesManagerScreen(),
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
    ],
  );
});
