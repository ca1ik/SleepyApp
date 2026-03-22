import 'package:flutter_test/flutter_test.dart';
import 'package:sleepy_ai/shared/services/atmospheric_music_manager.dart';

void main() {
  group('AtmosphericMusicManager', () {
    test('is a singleton', () {
      final a = AtmosphericMusicManager.instance;
      final b = AtmosphericMusicManager.instance;
      expect(identical(a, b), isTrue);
    });

    test('initial context is none', () {
      final mgr = AtmosphericMusicManager.instance;
      // After stop() to reset any prior test state.
      mgr.stop();
      expect(mgr.currentContext, AtmosphericContext.none);
    });

    test('default volume is 0.35', () {
      final mgr = AtmosphericMusicManager.instance;
      expect(mgr.volume, 0.35);
    });

    test('setVolume clamps to 0.0–1.0', () {
      final mgr = AtmosphericMusicManager.instance;
      mgr.setVolume(-0.5);
      expect(mgr.volume, 0.0);
      mgr.setVolume(2.0);
      expect(mgr.volume, 1.0);
      mgr.setVolume(0.5);
      expect(mgr.volume, 0.5);
      // Restore default for other tests.
      mgr.setVolume(0.35);
    });
  });

  group('AtmosphericContext', () {
    test('has exactly 6 values', () {
      expect(AtmosphericContext.values.length, 6);
    });

    test('contains expected contexts', () {
      expect(
          AtmosphericContext.values,
          containsAll([
            AtmosphericContext.galaxy,
            AtmosphericContext.zodiac,
            AtmosphericContext.astral,
            AtmosphericContext.games,
            AtmosphericContext.sleep,
            AtmosphericContext.none,
          ]));
    });
  });
}
