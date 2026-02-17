import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/services/database_service.dart';
import 'data/services/notification_service.dart';

late final GoRouter _router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database (singleton)
  final db = DatabaseService();
  await db.initHive();

  // Initialize notifications
  await NotificationService().initialize();

  // Check onboarding status and create router once
  final onboardingCompleted = db.settings.onboardingCompleted;
  _router = createRouter(onboardingCompleted: onboardingCompleted);

  runApp(
    ProviderScope(
      child: const ZzzApp(),
    ),
  );
}

class ZzzApp extends StatelessWidget {
  const ZzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zzz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
