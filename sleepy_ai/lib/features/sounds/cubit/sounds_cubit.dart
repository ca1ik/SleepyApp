import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleepy_ai/features/sounds/cubit/sounds_state.dart';
import 'package:sleepy_ai/features/sounds/data/sounds_repository.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

/// Cubit managing concurrent playback of multiple sound tracks.
/// Each ActiveSoundTrack has its own [AudioPlayer] instance.
class SoundsCubit extends Cubit<SoundsState> {
  SoundsCubit({required this.repository}) : super(const SoundsState()) {
    _loadSounds();
  }

  final SoundsRepository repository;

  /// soundId → AudioPlayer mapping (kept in memory).
  final Map<String, AudioPlayer> _players = {};

  static const int _maxTracks = 6;

  // ─── Initial load ───────────────────────────────────────────────

  Future<void> _loadSounds() async {
    emit(state.copyWith(isLoading: true));
    try {
      final sounds = await repository.getAllSounds();
      final favs = await repository.getFavorites();
      emit(
        state.copyWith(
          allSounds: sounds,
          favorites: favs,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
          state.copyWith(isLoading: false, error: 'Failed to load sounds: $e'));
    }
  }

  // ─── Sound toggle ──────────────────────────────────────────────

  Future<void> toggleSound(SoundModel sound) async {
    if (state.isTrackActive(sound.id)) {
      await removeTrack(sound.id);
    } else {
      await addTrack(sound);
    }
  }

  Future<void> addTrack(SoundModel sound) async {
    if (state.activeTracks.length >= _maxTracks) return;
    if (state.isTrackActive(sound.id)) return;

    final player = AudioPlayer();
    _players[sound.id] = player;

    final newTrack = ActiveSoundTrack(sound: sound, volume: 0.7);

    // Update state before playing so UI shows it immediately.
    final updated = List<ActiveSoundTrack>.from(state.activeTracks)
      ..add(newTrack);
    emit(state.copyWith(activeTracks: updated, isMixerVisible: true));

    try {
      await player.setUrl(sound.streamUrl);
      await player.setVolume(newTrack.volume);
      await player.setLoopMode(LoopMode.one);
      await player.play();
    } catch (e) {
      // Remove track that failed to play.
      await removeTrack(sound.id);
      emit(state.copyWith(error: '${sound.name} could not be played: $e'));
    }
  }

  Future<void> removeTrack(String soundId) async {
    final player = _players.remove(soundId);
    await player?.stop();
    await player?.dispose();

    final updated =
        state.activeTracks.where((t) => t.sound.id != soundId).toList();

    emit(
      state.copyWith(activeTracks: updated, isMixerVisible: updated.isNotEmpty),
    );
  }

  // ─── Ses seviyesi ────────────────────────────────────────────────────

  Future<void> setVolume(String soundId, double volume) async {
    final player = _players[soundId];
    await player?.setVolume(volume);

    final updated = state.activeTracks.map((t) {
      if (t.sound.id == soundId) return t.copyWith(volume: volume);
      return t;
    }).toList();

    emit(state.copyWith(activeTracks: updated));
  }

  // ─── Tüm sesleri duraklat / devam et ─────────────────────────────────

  Future<void> pauseAll() async {
    for (final player in _players.values) {
      await player.pause();
    }
    final updated =
        state.activeTracks.map((t) => t.copyWith(isPlaying: false)).toList();
    emit(state.copyWith(activeTracks: updated));
  }

  Future<void> resumeAll() async {
    for (final player in _players.values) {
      await player.play();
    }
    final updated =
        state.activeTracks.map((t) => t.copyWith(isPlaying: true)).toList();
    emit(state.copyWith(activeTracks: updated));
  }

  Future<void> stopAll() async {
    for (final player in _players.values) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
    emit(state.copyWith(activeTracks: [], isMixerVisible: false));
  }

  // ─── Favorites ────────────────────────────────────────────────────────

  Future<void> toggleFavorite(String soundId) async {
    final current = List<String>.from(state.favorites);
    if (current.contains(soundId)) {
      current.remove(soundId);
    } else {
      current.add(soundId);
    }
    emit(state.copyWith(favorites: current));
    await repository.saveFavorites(current);
  }

  // ─── Mixer visibility ───────────────────────────────────────────────

  void toggleMixerVisibility() {
    emit(state.copyWith(isMixerVisible: !state.isMixerVisible));
  }

  // ─── AI mood music suggestion ─────────────────────────────────────────────

  Future<void> askAiForSounds(String moodDescription) async {
    if (moodDescription.trim().isEmpty) return;
    emit(state.copyWith(aiMoodQuery: moodDescription, isAiLoading: true));
    try {
      final recommended = await repository.getAiRecommendedSounds(
        moodDescription,
      );
      emit(
        state.copyWith(aiRecommendedSounds: recommended, isAiLoading: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
            isAiLoading: false, error: 'Failed to get AI recommendations: $e'),
      );
    }
  }

  /// Stops all recommended sounds and starts a new 4-5 track mix.
  Future<void> applyAiRecommendations() async {
    final sounds = state.aiRecommendedSounds;
    if (sounds.isEmpty) return;
    await stopAll();
    for (final sound in sounds) {
      await addTrack(sound);
    }
  }

  // ─── Lifecycle ───────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    await stopAll();
    return super.close();
  }
}
