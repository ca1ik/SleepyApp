import 'dart:async';
import 'package:just_audio/just_audio.dart';

/// Context modes for atmospheric background music.
enum AtmosphericContext {
  /// Deep-space galaxy ambient — default when browsing the app.
  galaxy,

  /// Mystical zodiac mode — plays when in zodiac/horoscope screens.
  zodiac,

  /// Calm astral exercise music — plays during guided exercises.
  astral,

  /// Upbeat cosmic rhythm — plays during game sessions.
  games,

  /// Ultra-soft delta/theta waves — plays during sleep mode.
  sleep,

  /// Silence — no atmospheric music.
  none,
}

/// Manages a single atmospheric music track per context, with crossfade
/// transitions between contexts. Operates independently of [SoundsCubit]
/// (the mixer) to avoid conflicts; this service owns **one** player at a time.
///
/// Usage:
/// ```dart
/// final mgr = AtmosphericMusicManager.instance;
/// await mgr.setContext(AtmosphericContext.zodiac);
/// mgr.setVolume(0.5);
/// await mgr.stop();
/// ```
class AtmosphericMusicManager {
  AtmosphericMusicManager._();

  static final AtmosphericMusicManager instance = AtmosphericMusicManager._();

  AudioPlayer? _activePlayer;
  AudioPlayer? _fadingOutPlayer;
  Timer? _fadeInTimer;
  Timer? _fadeOutTimer;

  AtmosphericContext _currentContext = AtmosphericContext.none;
  double _targetVolume = 0.35;
  bool _disposed = false;

  AtmosphericContext get currentContext => _currentContext;
  double get volume => _targetVolume;
  bool get isPlaying => _activePlayer?.playing ?? false;

  // ─── Ambient track catalog (Freesound.org CC0/CC-BY previews) ───────────
  // Each context maps to a curated atmospheric stream URL.
  // Attribution: All from freesound.org under CC0 license.

  static const Map<AtmosphericContext, _AtmosphericTrack> _tracks = {
    AtmosphericContext.galaxy: _AtmosphericTrack(
      // Space ambience by BlastWaveFx (CC0) freesound#377251
      url: 'https://cdn.freesound.org/previews/377/377251_3905081-lq.mp3',
      label: 'Galaxy Ambient',
    ),
    AtmosphericContext.zodiac: _AtmosphericTrack(
      // Mystical Ambient by SoundsExciting (CC0) freesound#538079
      url: 'https://cdn.freesound.org/previews/538/538079_7552052-lq.mp3',
      label: 'Zodiac Mystique',
    ),
    AtmosphericContext.astral: _AtmosphericTrack(
      // Meditation Ambient by BearAudioDesign (CC0) freesound#474803
      url: 'https://cdn.freesound.org/previews/474/474803_6518837-lq.mp3',
      label: 'Astral Meditation',
    ),
    AtmosphericContext.games: _AtmosphericTrack(
      // Ambient Loop by ecfike (CC0) freesound#651383
      url: 'https://cdn.freesound.org/previews/651/651383_2462547-lq.mp3',
      label: 'Cosmic Games',
    ),
    AtmosphericContext.sleep: _AtmosphericTrack(
      // Deep Sleep Ambient by klankbeeld (CC0) freesound#462761
      url: 'https://cdn.freesound.org/previews/462/462761_1676145-lq.mp3',
      label: 'Deep Sleep',
    ),
  };

  // ─── Public API ────────────────────────────────────────────────────────

  /// Switch to a new atmospheric context with a crossfade transition.
  /// If [context] is the same as current, this is a no-op.
  Future<void> setContext(AtmosphericContext context) async {
    if (_disposed) return;
    if (context == _currentContext) return;

    if (context == AtmosphericContext.none) {
      await stop();
      return;
    }

    final track = _tracks[context];
    if (track == null) return;

    // Fade out the current player (if any).
    _beginFadeOut();

    _currentContext = context;

    // Create a new player for the incoming context.
    final player = AudioPlayer();
    _activePlayer = player;

    try {
      await player.setUrl(track.url);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(0.0);
      await player.play();
      _beginFadeIn(player);
    } catch (_) {
      // Stream unavailable — silently degrade; don't block the UI.
      _activePlayer = null;
      await player.dispose();
    }
  }

  /// Adjust the target volume (0.0 – 1.0). Applies immediately.
  void setVolume(double vol) {
    _targetVolume = vol.clamp(0.0, 1.0);
    _activePlayer?.setVolume(_targetVolume);
  }

  /// Pause atmospheric music (keeps context so it can resume).
  Future<void> pause() async {
    await _activePlayer?.pause();
  }

  /// Resume atmospheric music in the current context.
  Future<void> resume() async {
    if (_activePlayer != null && !(_activePlayer!.playing)) {
      await _activePlayer!.play();
    }
  }

  /// Stop and clear all atmospheric music. Resets context to [none].
  Future<void> stop() async {
    _cancelTimers();
    _currentContext = AtmosphericContext.none;

    await _disposePlayer(_activePlayer);
    _activePlayer = null;

    await _disposePlayer(_fadingOutPlayer);
    _fadingOutPlayer = null;
  }

  /// Call when the app lifecycle changes (e.g. AppLifecycleState.paused).
  Future<void> onAppPaused() async => pause();

  /// Call when the app lifecycle resumes.
  Future<void> onAppResumed() async => resume();

  /// Permanently release resources.
  Future<void> dispose() async {
    _disposed = true;
    await stop();
  }

  // ─── Crossfade engine ──────────────────────────────────────────────────

  static const int _fadeSteps = 20;
  static const Duration _fadeDuration = Duration(milliseconds: 1500);

  void _beginFadeIn(AudioPlayer player) {
    _fadeInTimer?.cancel();
    int step = 0;
    final interval = Duration(
      milliseconds: _fadeDuration.inMilliseconds ~/ _fadeSteps,
    );

    _fadeInTimer = Timer.periodic(interval, (timer) {
      step++;
      final progress = step / _fadeSteps;
      player.setVolume(_targetVolume * progress);
      if (step >= _fadeSteps) {
        timer.cancel();
        player.setVolume(_targetVolume);
      }
    });
  }

  void _beginFadeOut() {
    // Dispose the previously fading-out player first.
    _disposePlayer(_fadingOutPlayer);
    _fadingOutPlayer = _activePlayer;
    _activePlayer = null;

    final player = _fadingOutPlayer;
    if (player == null) return;

    _fadeOutTimer?.cancel();
    int step = 0;
    final startVol = player.volume;
    final interval = Duration(
      milliseconds: _fadeDuration.inMilliseconds ~/ _fadeSteps,
    );

    _fadeOutTimer = Timer.periodic(interval, (timer) {
      step++;
      final progress = 1.0 - (step / _fadeSteps);
      player.setVolume(startVol * progress);
      if (step >= _fadeSteps) {
        timer.cancel();
        _disposePlayer(player);
        if (_fadingOutPlayer == player) _fadingOutPlayer = null;
      }
    });
  }

  // ─── Helpers ───────────────────────────────────────────────────────────

  void _cancelTimers() {
    _fadeInTimer?.cancel();
    _fadeOutTimer?.cancel();
    _fadeInTimer = null;
    _fadeOutTimer = null;
  }

  Future<void> _disposePlayer(AudioPlayer? player) async {
    if (player == null) return;
    try {
      await player.stop();
      await player.dispose();
    } catch (_) {
      // Player may already be disposed.
    }
  }
}

/// Internal model for an atmospheric track.
class _AtmosphericTrack {
  const _AtmosphericTrack({required this.url, required this.label});
  final String url;
  final String label;
}
