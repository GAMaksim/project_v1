import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  final db = DatabaseService();
  await db.initHive();

  // Check onboarding status
  final onboardingCompleted = db.settings.onboardingCompleted;

  runApp(
    ProviderScope(
      child: ZzzApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

class ZzzApp extends StatelessWidget {
  final bool onboardingCompleted;

  const ZzzApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(onboardingCompleted: onboardingCompleted);

    return MaterialApp.router(
      title: 'Zzz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
