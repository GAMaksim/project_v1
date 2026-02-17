class SoundPreset {
  final String id;
  final String name;
  final String description;
  final String assetPath;
  final bool isPremium;
  final String icon;

  const SoundPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.isPremium,
    required this.icon,
  });
}

class Sounds {
  Sounds._();

  static const List<SoundPreset> all = [
    // Free sounds
    SoundPreset(
      id: 'white_noise',
      name: 'White Noise',
      description: 'Gentle static for deep focus and sleep',
      assetPath: 'assets/sounds/free/white_noise.mp3',
      isPremium: false,
      icon: '🌫️',
    ),
    SoundPreset(
      id: 'rain',
      name: 'Rain',
      description: 'Soft rainfall on a quiet night',
      assetPath: 'assets/sounds/free/rain.mp3',
      isPremium: false,
      icon: '🌧️',
    ),
    SoundPreset(
      id: 'ocean',
      name: 'Ocean',
      description: 'Calm waves washing ashore',
      assetPath: 'assets/sounds/free/ocean.mp3',
      isPremium: false,
      icon: '🌊',
    ),
    // Premium sounds
    SoundPreset(
      id: 'fireplace',
      name: 'Fireplace',
      description: 'Warm crackling fire',
      assetPath: 'assets/sounds/premium/fireplace.mp3',
      isPremium: true,
      icon: '🔥',
    ),
    SoundPreset(
      id: 'forest',
      name: 'Forest',
      description: 'Birds and gentle breeze through trees',
      assetPath: 'assets/sounds/premium/forest.mp3',
      isPremium: true,
      icon: '🌲',
    ),
    SoundPreset(
      id: 'piano',
      name: 'Piano',
      description: 'Soft classical piano melodies',
      assetPath: 'assets/sounds/premium/piano.mp3',
      isPremium: true,
      icon: '🎹',
    ),
    SoundPreset(
      id: 'meditation',
      name: 'Meditation',
      description: 'Tibetan bowls and ambient tones',
      assetPath: 'assets/sounds/premium/meditation.mp3',
      isPremium: true,
      icon: '🧘',
    ),
    SoundPreset(
      id: 'lullaby',
      name: 'Lullaby',
      description: 'Gentle music box melodies',
      assetPath: 'assets/sounds/premium/lullaby.mp3',
      isPremium: true,
      icon: '🎵',
    ),
  ];

  static List<SoundPreset> get free => all.where((s) => !s.isPremium).toList();
  static List<SoundPreset> get premium => all.where((s) => s.isPremium).toList();

  static SoundPreset? getById(String id) {
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
