import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzz/core/constants/sounds.dart';
import 'package:zzz/data/services/audio_service.dart';
import 'package:zzz/providers/settings_provider.dart';

/// Audio state for the UI.
class AudioState {
  final String? currentSoundId;
  final bool isPlaying;

  const AudioState({
    this.currentSoundId,
    this.isPlaying = false,
  });

  AudioState copyWith({
    String? currentSoundId,
    bool? isPlaying,
  }) {
    return AudioState(
      currentSoundId: currentSoundId ?? this.currentSoundId,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioService _audioService;
  final Ref _ref;
  StreamSubscription? _playingSub;

  AudioNotifier(this._audioService, this._ref) : super(const AudioState()) {
    // Listen to player state changes
    _playingSub = _audioService.playingStream.listen((playing) {
      state = AudioState(
        currentSoundId: _audioService.currentSoundId,
        isPlaying: playing,
      );
    });
  }

  /// Play a sound, checking premium access.
  Future<bool> playSound(SoundPreset preset) async {
    // Check premium access
    if (preset.isPremium) {
      final settings = _ref.read(settingsProvider);
      if (!settings.isPremium) {
        return false; // Needs premium
      }
    }

    await _audioService.playSound(preset.id, preset.assetPath);
    return true;
  }

  /// Pause current playback.
  Future<void> pause() async {
    await _audioService.pause();
  }

  /// Resume playback.
  Future<void> resume() async {
    await _audioService.resume();
  }

  /// Stop playback.
  Future<void> stop() async {
    await _audioService.stop();
    state = const AudioState();
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(AudioService(), ref);
});
