import 'package:flutter/material.dart';

/// Bir uyku masalındaki tek bir sahne.
class StoryScene {
  const StoryScene({
    required this.text,
    required this.durationSeconds,
    this.sceneType = SceneType.walking,
  });

  final String text;
  final int durationSeconds;
  final SceneType sceneType;
}

enum SceneType { walking, standing, looking, sleeping }

/// Tam bir interaktif uyku masalı.
class SleepStory {
  const SleepStory({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.emoji,
    required this.scenes,
    required this.characterEmoji,
    required this.bgGradientColors,
    required this.groundColor,
    required this.treeColor,
    required this.particleColor,
    required this.lampColor,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final String emoji;
  final List<StoryScene> scenes;
  final String characterEmoji;
  final List<Color> bgGradientColors;
  final Color groundColor;
  final Color treeColor;
  final Color particleColor;
  final Color lampColor;
}
