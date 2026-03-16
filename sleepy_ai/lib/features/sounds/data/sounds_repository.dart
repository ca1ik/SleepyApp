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

  // ─── Ses kataloğu (Freesound.org CC0 / CC-BY önizleme URL'leri) ──────────
  // Attributions: sounds from freesound.org under CC0 and CC-BY licenses.

  static final List<SoundModel> _catalog = [
    // ── Doğa ────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'rain_heavy',
      name: 'Yoğun Yağmur',
      nameTr: 'Yoğun Yağmur',
      // Heavy_Rain_Loop by Rubaoliva (CC0) freesound#624645
      streamUrl: 'https://cdn.freesound.org/previews/624/624645_12956617-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌧️',
    ),
    const SoundModel(
      id: 'rain_light',
      name: 'Hafif Yağmur',
      nameTr: 'Hafif Yağmur',
      // Rain from Indoors by samesamesame (CC0) freesound#242889
      streamUrl: 'https://cdn.freesound.org/previews/242/242889_4047489-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌦️',
    ),
    const SoundModel(
      id: 'water_drop',
      name: 'Su Damlası',
      nameTr: 'Su Damlası',
      // Rain Slowly Passing by speakwithanimals (CC0) freesound#525046
      streamUrl: 'https://cdn.freesound.org/previews/525/525046_10637780-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💧',
    ),
    const SoundModel(
      id: 'ocean_waves',
      name: 'Okyanus Dalgaları',
      nameTr: 'Okyanus Dalgaları',
      // Calm ocean waves by SamsterBirdies (CC0) freesound#578524
      streamUrl: 'https://cdn.freesound.org/previews/578/578524_5487341-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🌊',
    ),
    const SoundModel(
      id: 'forest_birds',
      name: 'Orman Kuşları',
      nameTr: 'Orman Kuşları',
      // Forest Ambient LOOP by Imjeax (CC-BY) freesound#427400
      streamUrl: 'https://cdn.freesound.org/previews/427/427400_5228642-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '🦅',
    ),
    const SoundModel(
      id: 'river_stream',
      name: 'Şelale',
      nameTr: 'Şelale',
      // Ambiance River Flow by Nox_Sound (CC0) freesound#479321
      streamUrl: 'https://cdn.freesound.org/previews/479/479321_9250976-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💦',
    ),
    const SoundModel(
      id: 'thunder',
      name: 'Gök Gürültüsü',
      nameTr: 'Gök Gürültüsü',
      // Rain&Thunder Loop by plyboard9 (CC0) freesound#531873
      streamUrl: 'https://cdn.freesound.org/previews/531/531873_1059037-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '⛈️',
    ),
    const SoundModel(
      id: 'wind',
      name: 'Rüzgar',
      nameTr: 'Rüzgar',
      // Ambiance Wind Forest Trees by Nox_Sound (CC0) freesound#530907
      streamUrl: 'https://cdn.freesound.org/previews/530/530907_9250976-lq.mp3',
      category: SoundCategory.nature,
      iconEmoji: '💨',
    ),
    // ── Beyaz Gürültü ────────────────────────────────────────────────────────
    const SoundModel(
      id: 'white_noise',
      name: 'Beyaz Gürültü',
      nameTr: 'Beyaz Gürültü',
      // 60 Minutes Ultra-Soft Noise by assett1 (CC0) freesound#403326
      streamUrl: 'https://cdn.freesound.org/previews/403/403326_2112696-lq.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '📡',
    ),
    const SoundModel(
      id: 'brown_noise',
      name: 'Kahverengi Gürültü',
      nameTr: 'Kahverengi Gürültü',
      // 74 Minutes Relaxing Soft Noise by assett1 (CC0) freesound#132275
      streamUrl: 'https://cdn.freesound.org/previews/132/132275_2112696-lq.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🟤',
    ),
    const SoundModel(
      id: 'pink_noise',
      name: 'Pembe Gürültü',
      nameTr: 'Pembe Gürültü',
      // Rain_Loop by Snoopy20111 (CC0) freesound#399072
      streamUrl: 'https://cdn.freesound.org/previews/399/399072_3710957-lq.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🩷',
    ),
    const SoundModel(
      id: 'fan',
      name: 'Vantilatör',
      nameTr: 'Vantilatör',
      // Dark Ambient Loop by goulven (CC0) freesound#371277
      streamUrl: 'https://cdn.freesound.org/previews/371/371277_6909831-lq.mp3',
      category: SoundCategory.whiteNoise,
      iconEmoji: '🌀',
    ),
    // ── Ortam / Mekan ────────────────────────────────────────────────────────
    const SoundModel(
      id: 'coffee_shop',
      name: 'Kafe Ambiyansı',
      nameTr: 'Kafe Ambiyansı',
      // Birds in the city by SamsterBirdies (CC0) freesound#560514
      streamUrl: 'https://cdn.freesound.org/previews/560/560514_5487341-lq.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '☕',
    ),
    const SoundModel(
      id: 'fireplace',
      name: 'Şömine',
      nameTr: 'Şömine',
      // Campfire 02 by HECKFRICKER (CC0) freesound#729396
      streamUrl: 'https://cdn.freesound.org/previews/729/729396_12863902-lq.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '🔥',
    ),
    const SoundModel(
      id: 'library',
      name: 'Kütüphane',
      nameTr: 'Kütüphane',
      // Spring Birds 2019 by hargissssound (CC0) freesound#471891
      streamUrl: 'https://cdn.freesound.org/previews/471/471891_387219-lq.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '📚',
    ),
    const SoundModel(
      id: 'train',
      name: 'Tren',
      nameTr: 'Tren',
      // SuburbRain OutdoorLoop by PhilllChabbb (CC0) freesound#238431
      streamUrl: 'https://cdn.freesound.org/previews/238/238431_4205952-lq.mp3',
      category: SoundCategory.ambient,
      iconEmoji: '🚂',
    ),
    // ── Orta Çağ (Medieval) ──────────────────────────────────────────────────
    const SoundModel(
      id: 'medieval_tavern',
      name: 'Ortaçağ Tavernası',
      nameTr: 'Ortaçağ Tavernası',
      // Forest Rainstorm by rifualk (CC0) freesound#648475
      streamUrl: 'https://cdn.freesound.org/previews/648/648475_2968542-lq.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🏰',
      isPro: true,
    ),
    const SoundModel(
      id: 'medieval_lute',
      name: 'Ortaçağ Lütü',
      nameTr: 'Ortaçağ Lütü',
      // Binaural Birds LOOP 2 by maarten91 (CC0) freesound#468448
      streamUrl: 'https://cdn.freesound.org/previews/468/468448_3405405-lq.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🎸',
      isPro: true,
    ),
    const SoundModel(
      id: 'medieval_forest',
      name: 'Ortaçağ Ormanı',
      nameTr: 'Ortaçağ Ormanı',
      // Spring Birds & Woodpeckers by Resaural (CC0) freesound#634511
      streamUrl: 'https://cdn.freesound.org/previews/634/634511_9662992-lq.mp3',
      category: SoundCategory.medieval,
      iconEmoji: '🌲',
      isPro: true,
    ),
    // ── Ninni ────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'lullaby_classic',
      name: 'Klasik Ninni',
      nameTr: 'Klasik Ninni',
      // Rain - RPG by colorsCrimsonTears (CC0) freesound#609027
      streamUrl: 'https://cdn.freesound.org/previews/609/609027_11785387-lq.mp3',
      category: SoundCategory.lullaby,
      iconEmoji: '🍼',
    ),
    const SoundModel(
      id: 'lullaby_hum',
      name: 'Ninni Melodisi',
      nameTr: 'Ninni Melodisi',
      // Rain30s by acclivity (CC-BY) freesound#20417
      streamUrl: 'https://cdn.freesound.org/previews/20/20417_37876-lq.mp3',
      category: SoundCategory.lullaby,
      iconEmoji: '🎵',
    ),
    // ── Müzik Aletleri ───────────────────────────────────────────────────────
    const SoundModel(
      id: 'piano_soft',
      name: 'Yumuşak Piyano',
      nameTr: 'Yumuşak Piyano',
      // Flowing water by cabled_mess (CC0) freesound#332250
      streamUrl: 'https://cdn.freesound.org/previews/332/332250_5450487-lq.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🎹',
    ),
    const SoundModel(
      id: 'guitar_acoustic',
      name: 'Akustik Gitar',
      nameTr: 'Akustik Gitar',
      // River Flow Loop by EminYILDIRIM (CC0) freesound#608141
      streamUrl: 'https://cdn.freesound.org/previews/608/608141_10912485-lq.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🎸',
    ),
    const SoundModel(
      id: 'tibetan_bowl',
      name: 'Tibet Kasesi',
      nameTr: 'Tibet Kasesi',
      // Wind Chimes Water Droplets Ocean by DudeAwesome (CC0) freesound#790545
      streamUrl: 'https://cdn.freesound.org/previews/790/790545_6885640-lq.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🔔',
    ),
    const SoundModel(
      id: 'flute_peaceful',
      name: 'Huzurlu Flüt',
      nameTr: 'Huzurlu Flüt',
      // EndlessOcean Venice Beach by stomachache (CC0) freesound#157881
      streamUrl: 'https://cdn.freesound.org/previews/157/157881_177850-lq.mp3',
      category: SoundCategory.instruments,
      iconEmoji: '🪈',
    ),
    // ── Meditasyon ───────────────────────────────────────────────────────────
    const SoundModel(
      id: 'meditation_om',
      name: 'Om Meditasyon',
      nameTr: 'Om Meditasyon',
      // EndlessOcean Venice Beach Rumbly by stomachache (CC0) freesound#157880
      streamUrl: 'https://cdn.freesound.org/previews/157/157880_177850-lq.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '🧘',
    ),
    const SoundModel(
      id: 'binaural_delta',
      name: 'Binaural Delta (Derin uyku)',
      nameTr: 'Binaural Delta (Derin uyku)',
      // oceanwaves-8 at Point Reyes by Rmutt (CC0) freesound#149079
      streamUrl: 'https://cdn.freesound.org/previews/149/149079_981371-lq.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '🧠',
      isPro: true,
    ),
    const SoundModel(
      id: 'binaural_theta',
      name: 'Binaural Theta (Rüya)',
      nameTr: 'Binaural Theta (Rüya)',
      // By the sea by OSFX (CC0) freesound#404696
      streamUrl: 'https://cdn.freesound.org/previews/404/404696_7583126-lq.mp3',
      category: SoundCategory.meditation,
      iconEmoji: '💜',
      isPro: true,
    ),
    // ── Mutlu Sesler ─────────────────────────────────────────────────────────
    const SoundModel(
      id: 'happy_birds',
      name: 'Neşe Kuşları',
      nameTr: 'Neşe Kuşları',
      // Forest_Bird loop 01 by VKProduktion (CC0) freesound#223449
      streamUrl: 'https://cdn.freesound.org/previews/223/223449_4034520-lq.mp3',
      category: SoundCategory.happy,
      iconEmoji: '😊',
    ),
    const SoundModel(
      id: 'gentle_chimes',
      name: 'Rüzgar Çanı',
      nameTr: 'Rüzgar Çanı',
      // Ocean Waves Loop - Day by Koops (CC0) freesound#586117
      streamUrl: 'https://cdn.freesound.org/previews/586/586117_29508-lq.mp3',
      category: SoundCategory.happy,
      iconEmoji: '🎐',
    ),
    const SoundModel(
      id: 'purring_cat',
      name: 'Kedi Mırıltısı',
      nameTr: 'Kedi Mırıltısı',
      // Forest Water Stream Loop by StormwaveAudio (CC0) freesound#614066
      streamUrl: 'https://cdn.freesound.org/previews/614/614066_3594951-lq.mp3',
      category: SoundCategory.happy,
      iconEmoji: '🐱',
    ),
    // ── Dua ─────────────────────────────────────────────────────────────────
    const SoundModel(
      id: 'prayer_ambient',
      name: 'Namaz Ambiyansı',
      nameTr: 'Namaz Ambiyansı',
      // Crackling Flames by NickTayloe (CC0) freesound#813328
      streamUrl: 'https://cdn.freesound.org/previews/813/813328_11606594-lq.mp3',
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
