import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Audio service for playing sleep sounds in a loop with auto-stop.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  Timer? _autoStopTimer;
  String? _currentSoundId;

  /// Whether audio is currently playing.
  bool get isPlaying => _player.playing;

  /// Currently playing sound ID.
  String? get currentSoundId => _currentSoundId;

  /// Current player state stream for UI updates.
  Stream<bool> get playingStream =>
      _player.playingStream;

  /// Play a sound from assets in a loop.
  Future<void> playSound(String soundId, String assetPath) async {
    try {
      // If same sound is playing, just toggle
      if (_currentSoundId == soundId && _player.playing) {
        await pause();
        return;
      }

      // Stop any current playback
      await stop();

      // Load and play
      await _player.setAsset(assetPath);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0.7);
      await _player.play();

      _currentSoundId = soundId;

      // Auto-stop after 60 minutes
      _autoStopTimer?.cancel();
      _autoStopTimer = Timer(const Duration(minutes: 60), () {
        stop();
      });

      debugPrint('Playing sound: $soundId');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  /// Pause playback.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback.
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop and reset.
  Future<void> stop() async {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    _currentSoundId = null;
    await _player.stop();
  }

  /// Set volume (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Dispose resources.
  Future<void> dispose() async {
    _autoStopTimer?.cancel();
    await _player.dispose();
  }
}
