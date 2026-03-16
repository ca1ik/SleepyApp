import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class SoundsState extends Equatable {
  const SoundsState({
    this.allSounds = const [],
    this.activeTracks = const [],
    this.isMixerVisible = false,
    this.isLoading = false,
    this.error,
    this.favorites = const [],
    this.aiMoodQuery = '',
    this.aiRecommendedSounds = const [],
    this.isAiLoading = false,
  });

  final List<SoundModel> allSounds;

  /// Şu an aktif olan mix'teki ses parçaları (maks 6).
  final List<ActiveSoundTrack> activeTracks;

  /// Mixer paneli görünür mü?
  final bool isMixerVisible;

  final bool isLoading;
  final String? error;

  /// Favorilenen ses ID'leri.
  final List<String> favorites;

  /// YZ modunu için kullanıcı ruh hali sorgusu.
  final String aiMoodQuery;

  /// YZ tarafından önerilen sesler.
  final List<SoundModel> aiRecommendedSounds;
  final bool isAiLoading;

  bool get hasTracks => activeTracks.isNotEmpty;
  bool get isAnyPlaying => activeTracks.any((t) => t.isPlaying);

  /// Bir sesin çalınıp çalınmadığını ID ile sorgular.
  bool isTrackActive(String soundId) =>
      activeTracks.any((t) => t.sound.id == soundId);

  double volumeOf(String soundId) {
    try {
      return activeTracks.firstWhere((t) => t.sound.id == soundId).volume;
    } catch (_) {
      return 0.7;
    }
  }

  SoundsState copyWith({
    List<SoundModel>? allSounds,
    List<ActiveSoundTrack>? activeTracks,
    bool? isMixerVisible,
    bool? isLoading,
    String? error,
    List<String>? favorites,
    String? aiMoodQuery,
    List<SoundModel>? aiRecommendedSounds,
    bool? isAiLoading,
    bool clearError = false,
  }) {
    return SoundsState(
      allSounds: allSounds ?? this.allSounds,
      activeTracks: activeTracks ?? this.activeTracks,
      isMixerVisible: isMixerVisible ?? this.isMixerVisible,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      favorites: favorites ?? this.favorites,
      aiMoodQuery: aiMoodQuery ?? this.aiMoodQuery,
      aiRecommendedSounds: aiRecommendedSounds ?? this.aiRecommendedSounds,
      isAiLoading: isAiLoading ?? this.isAiLoading,
    );
  }

  @override
  List<Object?> get props => [
    allSounds,
    activeTracks,
    isMixerVisible,
    isLoading,
    error,
    favorites,
    aiMoodQuery,
    aiRecommendedSounds,
    isAiLoading,
  ];
}
