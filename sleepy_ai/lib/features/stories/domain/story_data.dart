import 'package:flutter/material.dart';
import 'package:sleepy_ai/features/stories/domain/story_models.dart';

/// Uygulamada gösterilecek 5 interaktif uyku masalı.
final List<SleepStory> kSleepStories = [
  // ─── 1. Kırmızı Başlıklı Kız ──────────────────────────────────────
  SleepStory(
    id: 'red_riding_hood',
    titleKey: 'storyRedTitle',
    subtitleKey: 'storyRedSub',
    emoji: '🧒',
    characterEmoji: '🧒',
    bgGradientColors: const [
      Color(0xFF0B1A0F),
      Color(0xFF1A3318),
      Color(0xFF0D2818)
    ],
    groundColor: const Color(0xFF1B3A1F),
    treeColor: const Color(0xFF0F2D14),
    particleColor: const Color(0xFF4ADE80),
    lampColor: const Color(0xFFFFD700),
    scenes: const [
      StoryScene(
        text: 'storyRed01',
        durationSeconds: 12,
      ),
      StoryScene(
        text: 'storyRed02',
        durationSeconds: 14,
      ),
      StoryScene(
        text: 'storyRed03',
        durationSeconds: 14,
        sceneType: SceneType.looking,
      ),
      StoryScene(
        text: 'storyRed04',
        durationSeconds: 14,
      ),
      StoryScene(
        text: 'storyRed05',
        durationSeconds: 14,
        sceneType: SceneType.standing,
      ),
      StoryScene(
        text: 'storyRed06',
        durationSeconds: 16,
      ),
      StoryScene(
        text: 'storyRed07',
        durationSeconds: 14,
        sceneType: SceneType.looking,
      ),
      StoryScene(
        text: 'storyRed08',
        durationSeconds: 16,
        sceneType: SceneType.sleeping,
      ),
    ],
  ),

  // ─── 2. Ay Işığı Prensesi ─────────────────────────────────────────
  SleepStory(
    id: 'moon_princess',
    titleKey: 'storyMoonTitle',
    subtitleKey: 'storyMoonSub',
    emoji: '👸',
    characterEmoji: '👸',
    bgGradientColors: const [
      Color(0xFF0A0A2E),
      Color(0xFF1A1A4E),
      Color(0xFF0D0D3A)
    ],
    groundColor: const Color(0xFF1A1A40),
    treeColor: const Color(0xFF12123A),
    particleColor: const Color(0xFFC4B5FD),
    lampColor: const Color(0xFFE0E7FF),
    scenes: const [
      StoryScene(text: 'storyMoon01', durationSeconds: 12),
      StoryScene(text: 'storyMoon02', durationSeconds: 14),
      StoryScene(
          text: 'storyMoon03',
          durationSeconds: 14,
          sceneType: SceneType.looking),
      StoryScene(text: 'storyMoon04', durationSeconds: 14),
      StoryScene(
          text: 'storyMoon05',
          durationSeconds: 14,
          sceneType: SceneType.standing),
      StoryScene(
          text: 'storyMoon06',
          durationSeconds: 16,
          sceneType: SceneType.sleeping),
    ],
  ),

  // ─── 3. Yıldız Toplayıcı ──────────────────────────────────────────
  SleepStory(
    id: 'star_collector',
    titleKey: 'storyStarTitle',
    subtitleKey: 'storyStarSub',
    emoji: '⭐',
    characterEmoji: '🧑',
    bgGradientColors: const [
      Color(0xFF0C0C24),
      Color(0xFF1C1C44),
      Color(0xFF0E0E30)
    ],
    groundColor: const Color(0xFF18183E),
    treeColor: const Color(0xFF10102E),
    particleColor: const Color(0xFFFDE68A),
    lampColor: const Color(0xFFFDE68A),
    scenes: const [
      StoryScene(text: 'storyStar01', durationSeconds: 12),
      StoryScene(text: 'storyStar02', durationSeconds: 14),
      StoryScene(
          text: 'storyStar03',
          durationSeconds: 14,
          sceneType: SceneType.looking),
      StoryScene(text: 'storyStar04', durationSeconds: 14),
      StoryScene(
          text: 'storyStar05',
          durationSeconds: 14,
          sceneType: SceneType.standing),
      StoryScene(
          text: 'storyStar06',
          durationSeconds: 16,
          sceneType: SceneType.sleeping),
    ],
  ),

  // ─── 4. Büyülü Orman Cücesi ───────────────────────────────────────
  SleepStory(
    id: 'forest_gnome',
    titleKey: 'storyGnomeTitle',
    subtitleKey: 'storyGnomeSub',
    emoji: '🍄',
    characterEmoji: '🧙',
    bgGradientColors: const [
      Color(0xFF0D1B0D),
      Color(0xFF1A3A1A),
      Color(0xFF0A2A0A)
    ],
    groundColor: const Color(0xFF1A3A1A),
    treeColor: const Color(0xFF0D2D0D),
    particleColor: const Color(0xFF86EFAC),
    lampColor: const Color(0xFF4ADE80),
    scenes: const [
      StoryScene(text: 'storyGnome01', durationSeconds: 12),
      StoryScene(text: 'storyGnome02', durationSeconds: 14),
      StoryScene(
          text: 'storyGnome03',
          durationSeconds: 14,
          sceneType: SceneType.looking),
      StoryScene(text: 'storyGnome04', durationSeconds: 14),
      StoryScene(
          text: 'storyGnome05',
          durationSeconds: 14,
          sceneType: SceneType.standing),
      StoryScene(
          text: 'storyGnome06',
          durationSeconds: 16,
          sceneType: SceneType.sleeping),
    ],
  ),

  // ─── 5. Okyanus Rüyası ────────────────────────────────────────────
  SleepStory(
    id: 'ocean_dream',
    titleKey: 'storyOceanTitle',
    subtitleKey: 'storyOceanSub',
    emoji: '🐚',
    characterEmoji: '🧜',
    bgGradientColors: const [
      Color(0xFF051525),
      Color(0xFF0A2A45),
      Color(0xFF071D35)
    ],
    groundColor: const Color(0xFF0D3050),
    treeColor: const Color(0xFF082540),
    particleColor: const Color(0xFF67E8F9),
    lampColor: const Color(0xFF22D3EE),
    scenes: const [
      StoryScene(text: 'storyOcean01', durationSeconds: 12),
      StoryScene(text: 'storyOcean02', durationSeconds: 14),
      StoryScene(
          text: 'storyOcean03',
          durationSeconds: 14,
          sceneType: SceneType.looking),
      StoryScene(text: 'storyOcean04', durationSeconds: 14),
      StoryScene(
          text: 'storyOcean05',
          durationSeconds: 14,
          sceneType: SceneType.standing),
      StoryScene(
          text: 'storyOcean06',
          durationSeconds: 16,
          sceneType: SceneType.sleeping),
    ],
  ),
];
