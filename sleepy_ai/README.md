# 🌙 SleepyApp — Sleep Optimization & Wellness Companion

Welcome to the **SleepyApp** repository! This comprehensive Flutter application is designed to help users **improve their sleep quality** through intelligent tracking, ambient sound mixing, gamification, educational content, interactive sleep stories, zodiac-powered astral exercises, and 10 relaxing mini-games. Built with **Clean Architecture**, powered by **BLoC/Cubit state management**, supporting **13 languages** and **Dark/Light theme**, and fully functional offline.

---

## 🛠️ FEATURES (v2.0)

### 🛏️ Sleep Tracking & Analytics
- Manual or automatic sleep logging (bedtime & wake time pickers)
- **Sleep Quality Score** calculation (0-100) based on duration, deep sleep, and disturbance count
- 7-day weekly bar chart visualization (powered by `fl_chart`)
- **Sleep debt** calculation and **bedtime consistency** scoring
- Weekly average sleep duration tracking

### 🎵 Ambient Sound Mixer
- **40+ ambient sounds** across 9 categories: Nature, Rain, White Noise, Ambient, Medieval, Lullaby, Instruments, Meditation, Binaural
- **Up to 6 simultaneous tracks** with independent volume control per track
- Favorites system with persistent local storage
- Category-based filtering and floating mixer panel
- AI Mood Music recommendations (API-ready)

### 🎮 10 Relaxing Mini-Games
- **Breathing Exercise** — Guided 4-4-6-2 breathing cycle with animated circle, particle effects, and starfield background
- **Star Catcher** — Tap falling stars to collect points with increasing difficulty
- **Bubble Pop** — Physics-based bubble animations with haptic feedback
- **Sheep Counter** — Classic sleep-inducing sheep counting game
- **Sleep Films** — Curated collection of relaxation films with watch tracking
- **Dream Labyrinth** — Navigate through dreamlike mazes with ambient visuals
- **Moon Runner** — Endless runner across lunar landscapes
- **Nebula Match** — Memory card matching game with cosmic theme
- **Galaxy Puzzle** — Sliding puzzle with galaxy imagery
- **Cosmic Flow** — Zen-like flow drawing game with particle trails

### 📖 Interactive Sleep Stories (NEW)
- **5 immersive bedtime stories** with unique animated environments:
  - 🧒 **Red Riding Hood** — Moonlit forest walk with golden lamp
  - 👸 **The Moon Princess** — Celestial journey across silver meadows
  - ⭐ **The Star Collector** — Gathering fallen stars in the quiet night
  - 🍄 **The Forest Gnome** — A tiny guardian's nighttime patrol
  - 🐚 **Ocean Dream** — Drifting through bioluminescent waters
- **Walking character animation** with gas lamp glow effect
- **Parallax scrolling scenery** — 3-layer trees, twinkling stars, floating firefly particles
- **Auto-advancing story text** with fade transitions and scene progress dots
- **Text-to-Speech (TTS)** voice narration via `flutter_tts` (tap to listen)
- **Play/Pause, Forward/Back** controls for full story navigation
- Custom `CustomPainter`-based rendering for 60fps performance

### 🔮 Zodiac & Astral Exercises (NEW)
- **12 zodiac signs** with detailed sleep profiles and personality traits
- **Zodiac compatibility** checker between any two signs
- **5 astral exercises**: Astral Projection, Lucid Dreaming, Chakra Alignment, Cosmic Energy Meditation, Third Eye Activation
- Step-by-step guided exercise flow with breathing cues
- Difficulty levels: Beginner, Intermediate, Advanced

### 🏆 Gamification & Achievements
- **12 achievement badges** unlocked by sleep quality and game performance
- **XP-based level system** (1-99 levels with 99 unique titles)
- **RPG-style character progression**: Sleeping Seed 🌱 → Dream Bud 🌸 → Star Traveler ⭐ → ... → Sleep Immortal 👑
- **Daily quests** with streak tracking (Login +15 XP, Log Sleep +20 XP, Play Game +30 XP)
- Level 5+ gated behind PRO subscription

### 📚 Sleep Science Education
- **12+ science-backed articles**: Circadian rhythm, blue light effects, deep sleep stages, caffeine half-life, 4-7-8 breathing technique, melatonin, sleep hygiene, and more
- Category filters: Biology, Technology, Nutrition, Environment, Techniques, Sports, Psychology
- Full-text search and estimated reading time

### 💎 PRO Membership (In-App Purchase)
- Monthly and yearly subscription options
- Unlocks advanced analytics, premium sounds, AI recommendations, unlimited level system
- Purchase restore support for reinstalls

### 🤖 AI Sleep Assistant (NEW)
- Conversational AI chatbot for personalized sleep advice
- Context-aware recommendations based on user sleep data
- API-ready architecture for LLM integration

### ⚙️ Settings & Personalization
- **13 languages**: 🇬🇧 English, 🇹🇷 Turkish, 🇩🇪 German, 🇪🇸 Spanish, 🇫🇷 French, 🇮🇹 Italian, 🇨🇳 Chinese, 🇯🇵 Japanese, 🇰🇷 Korean, 🇸🇦 Arabic, 🇷🇺 Russian, 🇧🇷 Portuguese, 🇮🇳 Hindi
- **Dark / Light theme** toggle with animated sun/moon transition
- Sleep reminder notifications
- Bedtime schedule and sleep goal configuration
- Animated staggered settings page with 2-column language grid

### 💬 Feedback System
- 5-star rating selector
- Detailed text feedback with submission to backend (API-ready)

---

## 🔄 UPCOMING FEATURES (v2.1+)

- ✅ ~~Firebase Authentication integration~~ (Done)
- ✅ ~~13-language localization~~ (Done)
- ✅ ~~Dark/Light theme~~ (Done)
- ✅ ~~10 mini-games~~ (Done)
- ✅ ~~Interactive Sleep Stories with TTS~~ (Done)
- ✅ ~~Zodiac & Astral Exercises~~ (Done)
- ✅ ~~AI Sleep Assistant~~ (Done)
- 🔄 Backend API connection (sleep tips, AI story generator)
- ✨ Real In-App Purchase implementation (Google Play Billing)
- 📈 Firebase Cloud Messaging push notifications
- 🤖 AI-powered music & story recommendations (LLM integration)
- 🔥 Firebase Analytics / telemetry
- 🍎 iOS platform testing & App Store publishing
- 🌐 More interactive story content & seasonal stories

---

## 🏗️ ARCHITECTURE & TECH STACK

### Architecture Pattern
```
Clean Architecture + Repository Pattern
├── Presentation Layer   → BLoC / Cubit / Provider / GetX
├── Domain Layer         → Entities, Models, Business Logic
└── Data Layer           → Repositories (Local / Remote)
```

### State Management Strategy

| Approach | Used For | Reason |
|----------|----------|--------|
| **BLoC** | Auth, Sleep Tracking | Complex event-driven workflows |
| **Cubit** | Sounds, Learning, Rewards, Settings, Pro, Level, Feedback | Simpler state transitions |
| **Provider** | Theme | Global UI state (ChangeNotifier) |
| **GetX** | Navigation, Routing | Lightweight page management |

### Data Layer

| Technology | Purpose |
|------------|---------|
| **Hive** | Sleep logs, sound favorites (NoSQL local database) |
| **SharedPreferences** | User preferences, PRO status, level data |
| **FlutterSecureStorage** | Auth tokens, sensitive data |
| **Dio** | HTTP client with interceptors (Firebase/API ready) |

### Error Handling

Functional error handling with `Either<Failure, Success>` pattern (dartz package):
```
ServerFailure | NetworkFailure | CacheFailure | AuthFailure
ValidationFailure | PurchaseFailure | PlatformFailure | UnknownFailure
```

### Platform Integration
- **MethodChannel** (`com.sleepyapp.sleepy_ai/alarm`) — Android native alarm scheduling
- **In-App Purchase** — Google Play Billing framework
- **Local Notifications** — Sleep reminder notifications

---

## 📁 PROJECT STRUCTURE

```
lib/
├── main.dart                          # App entry point, DI setup, BLoC providers
├── core/
│   ├── constants/                     # Colors, sizes, strings, durations
│   ├── di/                            # Manual Dependency Injection container
│   ├── error/                         # Custom Failure classes
│   ├── l10n/                          # Localization configuration
│   ├── network/                       # Dio client, Auth/Error/Logging interceptors
│   ├── platform/                      # MethodChannel (alarm service)
│   ├── router/                        # GetX route definitions (30+ pages)
│   ├── theme/                         # Dark & Light theme, color scheme, ThemeProvider
│   └── utils/                         # Extensions, SleepDurationCalculator
├── features/
│   ├── auth/                          # Authentication (Mock → Firebase ready)
│   │   ├── bloc/                      # AuthBloc, AuthEvent, AuthState
│   │   ├── data/                      # AuthRepository (mock implementation)
│   │   └── presentation/             # Splash, Login, Register, ForgotPassword
│   ├── dashboard/                     # Main hub with 5-tab navigation
│   ├── feedback/                      # User feedback (rating + message)
│   ├── games/                         # 10 mini-games + hub page
│   ├── learning/                      # Educational articles with search & filter
│   ├── level_system/                  # RPG progression (XP, quests, 99 levels)
│   ├── pro/                           # PRO subscription paywall (IAP)
│   ├── rewards/                       # Achievement badge system (12 badges)
│   ├── settings/                      # Language, theme, notifications, sleep goal
│   ├── sleep_tracking/                # Sleep logging, charts, quality scoring
│   ├── sounds/                        # Multi-track sound mixer (40+ sounds)
│   ├── stories/                       # 5 interactive sleep stories with TTS
│   └── zodiac/                        # Zodiac signs, compatibility, astral exercises
├── l10n/                              # ARB translation files (13 languages)
└── shared/
    ├── models/                        # UserEntity, SleepEntity, SoundModel, BadgeModel
    └── widgets/                       # GradientBackground, GlassCard, MetricCard, SleepChart
```

---

## 📦 DEPENDENCIES

### State Management
| Package | Version | Description |
|---------|---------|-------------|
| `flutter_bloc` | ^8.1.6 | BLoC pattern state management |
| `bloc` | ^8.1.4 | BLoC core library |
| `get` | ^4.6.6 | Navigation & route management |
| `provider` | ^6.1.2 | Global state (ThemeProvider) |
| `equatable` | ^2.0.5 | Value equality comparisons |

### Networking & Data
| Package | Version | Description |
|---------|---------|-------------|
| `dio` | ^5.7.0 | HTTP client with interceptor support |
| `connectivity_plus` | ^6.0.5 | Internet connectivity checking |
| `hive_flutter` | ^1.1.0 | NoSQL local database |
| `hive` | ^2.2.3 | Hive core |
| `shared_preferences` | ^2.3.2 | Key-value storage |
| `flutter_secure_storage` | ^9.2.2 | Secure token storage |

### Audio & Media
| Package | Version | Description |
|---------|---------|-------------|
| `just_audio` | ^0.9.40 | Audio playback (multi-player) |
| `audio_service` | ^0.18.15 | Background audio service |
| `audio_session` | ^0.1.21 | Audio session management |
| `flutter_tts` | ^4.2.0 | Text-to-Speech for story narration |

### UI & Animations
| Package | Version | Description |
|---------|---------|-------------|
| `fl_chart` | ^0.69.0 | Charts & data visualization |
| `lottie` | ^3.1.2 | Lottie animations |
| `shimmer` | ^3.0.0 | Loading shimmer effect |
| `cached_network_image` | ^3.4.1 | Cached network images |
| `google_fonts` | ^6.2.1 | Google Fonts (Poppins, Raleway) |
| `flutter_svg` | ^2.0.10+1 | SVG image support |

### In-App Purchase
| Package | Version | Description |
|---------|---------|-------------|
| `in_app_purchase` | ^3.2.0 | In-app purchase framework |
| `in_app_purchase_android` | ^0.3.6 | Android IAP implementation |

### Notifications & Permissions
| Package | Version | Description |
|---------|---------|-------------|
| `permission_handler` | ^11.3.1 | App permission management |
| `flutter_local_notifications` | ^17.2.2 | Local push notifications |

### Functional Programming & Utilities
| Package | Version | Description |
|---------|---------|-------------|
| `dartz` | ^0.10.1 | Either type (functional error handling) |
| `logger` | ^2.4.0 | Colorful console logging |
| `uuid` | ^4.5.1 | Unique ID generation |
| `intl` | 0.20.2 | Date/time formatting, localization |

### Dev Dependencies
| Package | Version | Description |
|---------|---------|-------------|
| `flutter_lints` | ^5.0.0 | Lint rules |
| `mockito` | ^5.4.4 | Test mocking |
| `build_runner` | ^2.4.13 | Code generation |
| `hive_generator` | ^2.0.1 | Hive TypeAdapter generation |

---

## 🎨 DESIGN SYSTEM

### Color Palette
| Color | Hex | Usage |
|-------|-----|-------|
| 🟣 Primary Purple | `#7C3AED` | Main brand color |
| 🩷 Accent Pink | `#EC4899` | Gradient highlights |
| ⬛ Dark Background | `#0A0118` | Main background |
| 🟪 Deep Purple | `#2D0A6B` | Card backgrounds |
| 🟢 Teal | — | Good performance indicators |
| 🟡 Gold | — | Earned achievement badges |

### Typography
- **Heading font**: Raleway (Google Fonts)
- **Body font**: Poppins (Google Fonts)
- **Material 3** design system

### Reusable UI Components
- 🌧️ **GradientBackground** — Animated purple gradient with rain particle effects
- 🪟 **GlassCard** — Frosted glass morphism container
- 📊 **MetricCardWidget** — Metric display card (value + unit + title)
- 📈 **SleepChartWidget** — 7-day sleep bar chart (fl_chart)
- 🔘 **GradientButton** — Gradient-filled button with loading spinner

---

## 📚 INSTALLATION GUIDE

### Prerequisites
- Flutter SDK `^3.5.0`
- Dart SDK `^3.5.0`
- Android Studio / VS Code
- Android Emulator or physical device

### STEP-BY-STEP:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/[username]/SleepyApp.git
   cd SleepyApp/sleepy_ai
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run Code Generation** (if needed):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the App:**
   ```bash
   flutter run
   ```

5. **Configure Settings:** Use the in-app settings to adjust language, sleep goals, and notification preferences.

### Firebase Integration (Optional)

1. Create a project in Firebase Console
2. Place `google-services.json` into `android/app/` directory
3. Uncomment Firebase packages in `pubspec.yaml`
4. Uncomment Firebase import and `Firebase.initializeApp()` in `main.dart`
5. Replace Mock repositories with Firebase repositories in `injection_container.dart`

---

## 📄 License

This project is developed for private use.

---

<p align="center">
  <b>🌙 SleepyApp</b> — Better sleep, better life.
</p>
