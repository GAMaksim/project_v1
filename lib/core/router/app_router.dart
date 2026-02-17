import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/schedule/schedule_setup_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/soundscapes/soundscapes_screen.dart';
import '../../ui/screens/statistics/statistics_screen.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../ui/shared/app_bottom_nav.dart';

// Shell route key for bottom navigation
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({required bool onboardingCompleted}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: onboardingCompleted ? '/' : '/onboarding',
    routes: [
      // Onboarding (no bottom nav)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Schedule setup (no bottom nav)
      GoRoute(
        path: '/schedule-setup',
        builder: (context, state) => const ScheduleSetupScreen(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/sounds',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SoundscapesScreen(),
            ),
          ),
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/sounds')) return 1;
    if (location.startsWith('/progress')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/sounds');
              break;
            case 2:
              context.go('/progress');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}
