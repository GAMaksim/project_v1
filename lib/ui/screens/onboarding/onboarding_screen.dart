import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/providers/settings_provider.dart';
import 'package:zzz/ui/shared/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: '🌙',
      title: 'Zzz',
      subtitle: 'Your personal sleep ritual coach.\nBetter evenings, better mornings.',
    ),
    _OnboardingPage(
      icon: '⏰',
      title: 'Smart Reminders',
      subtitle:
          'Gentle nudges throughout your evening.\nFrom dinner to bedtime — we\'ve got you.',
    ),
    _OnboardingPage(
      icon: '📊',
      title: 'Track Progress',
      subtitle: 'See your sleep patterns improve\nover time with beautiful insights.',
      showButton: true,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onBegin() async {
    await ref
        .read(settingsProvider.notifier)
        .setOnboardingCompleted(true);

    if (mounted) {
      context.go('/schedule-setup');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: _onBegin,
                        child: Text(
                          'Skip',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          page.icon,
                          style: const TextStyle(fontSize: 80),
                        )
                            .animate(
                                key: ValueKey('icon_$index'))
                            .fadeIn(duration: 500.ms)
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1.0, 1.0),
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: index == 0
                              ? AppTextStyles.displayLarge.copyWith(
                                  fontSize: 64,
                                  color: AppColors.deepIndigo,
                                )
                              : AppTextStyles.displayMedium,
                          textAlign: TextAlign.center,
                        )
                            .animate(
                                key: ValueKey('title_$index'))
                            .fadeIn(duration: 500.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(
                                key: ValueKey('sub_$index'))
                            .fadeIn(duration: 500.ms, delay: 400.ms),
                        if (page.showButton) ...[
                          const SizedBox(height: 48),
                          PrimaryButton(
                            text: 'Begin Your Journey',
                            onPressed: _onBegin,
                          )
                              .animate(
                                  key: ValueKey('btn_$index'))
                              .fadeIn(duration: 500.ms, delay: 600.ms)
                              .slideY(
                                begin: 0.3,
                                end: 0,
                                duration: 500.ms,
                                curve: Curves.easeOut,
                              ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.deepIndigo
                          : AppColors.whisperGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String icon;
  final String title;
  final String subtitle;
  final bool showButton;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showButton = false,
  });
}
