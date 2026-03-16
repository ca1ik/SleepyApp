import 'package:hive_flutter/hive_flutter.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

abstract class SoundsRepository {
  Future<List<SoundModel>> getAllSounds();
  Future<List<String>> getFavorites();
  Future<void> saveFavorites(List<String> ids);
  Future<List<SoundModel>> getAiRecommendedSounds(String moodDescription);
}

/// Sesler veritabanını dönen uygulama — gerçek projede CDN URL'leri kullanılır.
class LocalSoundsRepository implements SoundsRepository {
  static const _favoriteKey = 'sound_favorites';

  // ─── Ses kataloğu (URL'ler CDN'den gelecek) ───────────────────────────────

  static final List<SoundModel> _catalog = [
    // ── Doğa ────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'rain_heavy',
      name: 'Yoğun Yağmur',
      nameTr: 'Yoğun Yağmur',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/rain_heavy.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌧️',
    ),
    const SoundModel(
      id: 'rain_light',
      name: 'Hafif Yağmur',
      nameTr: 'Hafif Yağmur',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/rain_light.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌦️',
    ),
    const SoundModel(
      id: 'water_drop',
      name: 'Su Damlası',
      nameTr: 'Su Damlası',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/water_drop.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💧',
    ),
    const SoundModel(
      id: 'ocean_waves',
      name: 'Okyanus Dalgaları',
      nameTr: 'Okyanus Dalgaları',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/ocean_waves.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌊',
    ),
    const SoundModel(
      id: 'forest_birds',
      name: 'Orman Kuşları',
      nameTr: 'Orman Kuşları',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/forest_birds.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🦅',
    ),
    const SoundModel(
      id: 'river_stream',
      name: 'Şelale',
      nameTr: 'Şelale',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/river_stream.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💦',
    ),
    const SoundModel(
      id: 'thunder',
      name: 'Gök Gürültüsü',
      nameTr: 'Gök Gürültüsü',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/thunder.mp3',
      category: SoundCategory.nature,
      iconEmoji: '⛈️',
    ),
    const SoundModel(
      id: 'wind',
      name: 'Rüzgar',
      nameTr: 'Rüzgar',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/wind.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💨',
    ),
    // ── Beyaz Gürültü ────────────────────────────────────────────────────────
    const SoundModel(
      id: 'white_noise',
      name: 'Beyaz Gürültü',
      nameTr: 'Beyaz Gürültü',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/white_noise.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '📡',
    ),
    const SoundModel(
      id: 'brown_noise',
      name: 'Kahverengi Gürültü',
      nameTr: 'Kahverengi Gürültü',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/brown_noise.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🟤',
    ),
    const SoundModel(
      id: 'pink_noise',
      name: 'Pembe Gürültü',
      nameTr: 'Pembe Gürültü',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/pink_noise.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🩷',
    ),
    const SoundModel(
      id: 'fan',
      name: 'Vantilatör',
      nameTr: 'Vantilatör',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/fan.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🌀',
    ),
    // ── Ortam / Mekan ────────────────────────────────────────────────────────
    const SoundModel(
      id: 'coffee_shop',
      name: 'Kafe Ambiyansı',
      nameTr: 'Kafe Ambiyansı',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/coffee_shop.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '☕',
    ),
    const SoundModel(
      id: 'fireplace',
      name: 'Şömine',
      nameTr: 'Şömine',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/fireplace.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '🔥',
    ),
    const SoundModel(
      id: 'library',
      name: 'Kütüphane',
      nameTr: 'Kütüphane',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/library.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '📚',
    ),
    const SoundModel(
      id: 'train',
      name: 'Tren',
      nameTr: 'Tren',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/train.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '🚂',
    ),
    // ── Orta Çağ (Medieval) ──────────────────────────────────────────────────
    const SoundModel(
      id: 'medieval_tavern',
      name: 'Ortaçağ Tavernası',
      nameTr: 'Ortaçağ Tavernası',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/medieval_tavern.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🏰',
      isPro: true,
    ),
    const SoundModel(
      id: 'medieval_lute',
      name: 'Ortaçağ Lütü',
      nameTr: 'Ortaçağ Lütü',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/medieval_lute.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🎸',
      isPro: true,
    ),
    const SoundModel(
      id: 'medieval_forest',
      name: 'Ortaçağ Ormanı',
      nameTr: 'Ortaçağ Ormanı',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/medieval_forest.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🌲',
      isPro: true,
    ),
    // ── Ninni ────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'lullaby_classic',
      name: 'Klasik Ninni',
      nameTr: 'Klasik Ninni',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/lullaby_classic.mp3',
      category: SoundCategory.lullaby,
      iconEmoji: '🍼',
    ),
    const SoundModel(
      id: 'lullaby_hum',
      name: 'Ninni Melodisi',
      nameTr: 'Ninni Melodisi',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/lullaby_hum.mp3',
      category: SoundCategory.lullaby,
      iconEmoji: '🎵',
    ),
    // ── Müzik Aletleri ───────────────────────────────────────────────────────
    const SoundModel(
      id: 'piano_soft',
      name: 'Yumuşak Piyano',
      nameTr: 'Yumuşak Piyano',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/piano_soft.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🎹',
    ),
    const SoundModel(
      id: 'guitar_acoustic',
      name: 'Akustik Gitar',
      nameTr: 'Akustik Gitar',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/guitar_acoustic.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🎸',
    ),
    const SoundModel(
      id: 'tibetan_bowl',
      name: 'Tibet Kasesi',
      nameTr: 'Tibet Kasesi',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/tibetan_bowl.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🔔',
    ),
    const SoundModel(
      id: 'flute_peaceful',
      name: 'Huzurlu Flüt',
      nameTr: 'Huzurlu Flüt',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/flute_peaceful.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🪈',
    ),
    // ── Meditasyon ───────────────────────────────────────────────────────────
    const SoundModel(
      id: 'meditation_om',
      name: 'Om Meditasyon',
      nameTr: 'Om Meditasyon',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/meditation_om.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '🧘',
    ),
    const SoundModel(
      id: 'binaural_delta',
      name: 'Binaural Delta (Derin uyku)',
      nameTr: 'Binaural Delta (Derin uyku)',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/binaural_delta.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '🧠',
      isPro: true,
    ),
    const SoundModel(
      id: 'binaural_theta',
      name: 'Binaural Theta (Rüya)',
      nameTr: 'Binaural Theta (Rüya)',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/binaural_theta.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '💜',
      isPro: true,
    ),
    // ── Mutlu Sesler ─────────────────────────────────────────────────────────
    const SoundModel(
      id: 'happy_birds',
      name: 'Nese Kuşları',
      nameTr: 'Nese Kuşları',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/happy_birds.mp3',
      category: SoundCategory.happy,
      iconEmoji: '😊',
    ),
    const SoundModel(
      id: 'gentle_chimes',
      name: 'Rüzgar Çanı',
      nameTr: 'Rüzgar Çanı',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/gentle_chimes.mp3',
      category: SoundCategory.happy,
      iconEmoji: '🎐',
    ),
    const SoundModel(
      id: 'purring_cat',
      name: 'Kedi Mırıltısı',
      nameTr: 'Kedi Mırıltısı',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/purring_cat.mp3',
      category: SoundCategory.happy,
      iconEmoji: '🐱',
    ),
    // ── Dua ─────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'prayer_ambient',
      name: 'Namaz Ambiyansı',
      nameTr: 'Namaz Ambiyansı',
      streamUrl: 'https://cdn.sleepyapp.io/sounds/prayer_ambient.mp3',
      category: SoundCategory.prayer,
      iconEmoji: '🤲',
    ),
  ];

  // ─── YZ keyword → ses ID'leri eşleşmesi (mock implementasyon) ─────────────

  static const Map<String, List<String>> _moodKeywords = {
    'üzgün': ['rain_light', 'piano_soft', 'fireplace'],
    'sad': ['rain_light', 'piano_soft', 'fireplace'],
    'stresli': ['white_noise', 'meditation_om', 'tibetan_bowl'],
    'stressed': ['white_noise', 'meditation_om', 'tibetan_bowl'],
    'mutlu': ['happy_birds', 'forest_birds', 'gentle_chimes'],
    'happy': ['happy_birds', 'forest_birds', 'gentle_chimes'],
    'yalnız': ['fireplace', 'rain_heavy', 'purring_cat'],
    'lonely': ['fireplace', 'rain_heavy', 'purring_cat'],
    'yorgun': ['brown_noise', 'ocean_waves', 'binaural_delta'],
    'tired': ['brown_noise', 'ocean_waves', 'binaural_delta'],
    'odaklanmak': ['coffee_shop', 'library', 'brown_noise'],
    'focus': ['coffee_shop', 'library', 'brown_noise'],
    'meditasyon': ['meditation_om', 'tibetan_bowl', 'binaural_theta'],
    'meditation': ['meditation_om', 'tibetan_bowl', 'binaural_theta'],
    'ninni': ['lullaby_classic', 'lullaby_hum', 'piano_soft'],
    'lullaby': ['lullaby_classic', 'lullaby_hum', 'piano_soft'],
    'ortaçağ': ['medieval_tavern', 'medieval_lute', 'medieval_forest'],
    'medieval': ['medieval_tavern', 'medieval_lute', 'medieval_forest'],
  };

  @override
  Future<List<SoundModel>> getAllSounds() async => List.unmodifiable(_catalog);

  @override
  Future<List<String>> getFavorites() async {
    final box = Hive.box(AppStrings.boxFavorites);
    final raw = box.get(_favoriteKey);
    if (raw == null) return [];
    return List<String>.from(raw as List);
  }

  @override
  Future<void> saveFavorites(List<String> ids) async {
    final box = Hive.box(AppStrings.boxFavorites);
    await box.put(_favoriteKey, ids);
  }

  @override
  Future<List<SoundModel>> getAiRecommendedSounds(
    String moodDescription,
  ) async {
    // Gerçek projede bir LLM API'sine istek atılır; şimdilik keyword eşleme.
    final query = moodDescription.toLowerCase();
    final matchedIds = <String>{};

    for (final entry in _moodKeywords.entries) {
      if (query.contains(entry.key)) {
        matchedIds.addAll(entry.value);
      }
    }

    if (matchedIds.isEmpty) {
      // Genel rahatlatıcı seçim
      matchedIds.addAll(['ocean_waves', 'white_noise', 'piano_soft']);
    }

    return _catalog.where((s) => matchedIds.contains(s.id)).take(4).toList();
  }
}
