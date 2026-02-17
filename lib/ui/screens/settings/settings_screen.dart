import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/providers/settings_provider.dart';
import 'package:zzz/ui/widgets/premium_paywall.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Text(
                'Settings',
                style: AppTextStyles.displaySmall,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 24),

              // === Sleep Schedule ===
              _SectionHeader(title: 'Sleep'),
              _SettingsTile(
                icon: Icons.bedtime_outlined,
                title: 'Sleep Schedule',
                subtitle: 'Edit your bedtime for each day',
                onTap: () => context.push('/schedule-setup'),
              ),

              const SizedBox(height: 24),

              // === Notifications ===
              _SectionHeader(title: 'Notifications'),
              _SettingsToggle(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: settings.notificationsEnabled
                    ? 'Evening reminders are on'
                    : 'Evening reminders are off',
                value: settings.notificationsEnabled,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier)
                      .setNotificationsEnabled(val);
                },
              ),

              const SizedBox(height: 24),

              // === Language ===
              _SectionHeader(title: 'Language'),
              _SettingsSelector(
                icon: Icons.language,
                title: 'Language',
                value: settings.language == 'ru' ? 'Русский' : 'English',
                options: const ['English', 'Русский'],
                onSelected: (val) {
                  ref.read(settingsProvider.notifier)
                      .setLanguage(val == 'Русский' ? 'ru' : 'en');
                },
              ),

              const SizedBox(height: 24),

              // === Premium ===
              _SectionHeader(title: 'Subscription'),
              GestureDetector(
                onTap: settings.isPremium
                    ? null
                    : () async {
                        final purchased =
                            await PremiumPaywall.show(context);
                        if (purchased == true) {
                          ref
                              .read(settingsProvider.notifier)
                              .setPremium(true);
                        }
                      },
                child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepIndigo,
                      AppColors.softMauve,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('👑', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settings.isPremium
                                ? 'Premium Active'
                                : 'Upgrade to Premium',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            settings.isPremium
                                ? 'All features unlocked'
                                : 'Unlock all sounds & statistics',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!settings.isPremium)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 18,
                      ),
                  ],
                ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 24),

              // === About ===
              _SectionHeader(title: 'About'),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  // TODO: Add url_launcher and open privacy policy
                },
              ),
              _SettingsTile(
                icon: Icons.star_outline,
                title: 'Rate App',
                subtitle: 'Love Zzz? Leave a review!',
                onTap: () {
                  // TODO: Open store page
                },
              ),
              _SettingsTile(
                icon: Icons.share_outlined,
                title: 'Share App',
                onTap: () {
                  // TODO: Share link
                },
              ),

              const SizedBox(height: 16),

              // Version
              Center(
                child: Text(
                  'Zzz v1.0.0',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// === Helper Widgets ===

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.whisperGray),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.deepIndigo, size: 22),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.whisperGray),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: AppColors.deepIndigo, size: 22),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        activeColor: AppColors.deepIndigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _SettingsSelector extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _SettingsSelector({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.whisperGray),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.cream,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.whisperGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.map((opt) => ListTile(
                        title: Text(opt, style: AppTextStyles.labelLarge),
                        trailing: opt == value
                            ? const Icon(Icons.check_circle,
                                color: AppColors.deepIndigo)
                            : null,
                        onTap: () {
                          onSelected(opt);
                          Navigator.pop(ctx);
                        },
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        leading: Icon(icon, color: AppColors.deepIndigo, size: 22),
        title: Text(title, style: AppTextStyles.labelLarge),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
