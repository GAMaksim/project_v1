import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/constants/sounds.dart';
import 'package:zzz/providers/audio_provider.dart';
import 'package:zzz/providers/settings_provider.dart';
import 'package:zzz/ui/widgets/music_preset_tile.dart';

class SoundscapesScreen extends ConsumerWidget {
  const SoundscapesScreen({super.key});

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🔒 Premium Sound',
          style: AppTextStyles.headlineMedium,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unlock all 8 premium soundscapes for deeper, more restful sleep.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepIndigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Upgrade to Premium',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Maybe later',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final settings = ref.watch(settingsProvider);
    final isPremium = settings.isPremium;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soundscapes',
                    style: AppTextStyles.displaySmall,
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 4),
                  Text(
                    'Sounds to guide you to sleep',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sound list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Free section
                  Text(
                    'Free',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...Sounds.free.map((preset) {
                    final isCurrentPlaying =
                        audioState.currentSoundId == preset.id &&
                            audioState.isPlaying;
                    return MusicPresetTile(
                      preset: preset,
                      isPlaying: isCurrentPlaying,
                      isLocked: false,
                      onTap: () {
                        ref.read(audioProvider.notifier).playSound(preset);
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // Premium section
                  Row(
                    children: [
                      Text(
                        'Premium',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.softMauve.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'PRO',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.softMauve,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...Sounds.premium.map((preset) {
                    final isCurrentPlaying =
                        audioState.currentSoundId == preset.id &&
                            audioState.isPlaying;
                    final isLocked = !isPremium;
                    return MusicPresetTile(
                      preset: preset,
                      isPlaying: isCurrentPlaying,
                      isLocked: isLocked,
                      onTap: () async {
                        if (isLocked) {
                          _showPremiumDialog(context);
                        } else {
                          ref.read(audioProvider.notifier).playSound(preset);
                        }
                      },
                    );
                  }),

                  const SizedBox(height: 100), // Space for mini-player
                ],
              ),
            ),

            // Mini-player
            if (audioState.isPlaying && audioState.currentSoundId != null)
              _MiniPlayer(
                soundId: audioState.currentSoundId!,
                onPause: () => ref.read(audioProvider.notifier).pause(),
                onStop: () => ref.read(audioProvider.notifier).stop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  final String soundId;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const _MiniPlayer({
    required this.soundId,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final preset = Sounds.getById(soundId);
    if (preset == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.deepIndigo,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepIndigo.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(preset.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  preset.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Playing • Auto-stop in 60 min',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPause,
            icon: const Icon(Icons.pause, color: Colors.white),
            iconSize: 28,
          ),
          IconButton(
            onPressed: onStop,
            icon: const Icon(Icons.stop, color: Colors.white70),
            iconSize: 24,
          ),
        ],
      ),
    ).animate().slideY(
          begin: 1.0,
          end: 0.0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
