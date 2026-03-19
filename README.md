# 🌙 SleepyApp — Sleep Optimization & Wellness Companion

Welcome to the **SleepyApp** repository! This comprehensive Flutter application is designed to help users **improve their sleep quality** through intelligent tracking, ambient sound mixing, gamification, educational content, and relaxing mini-games. Built with **Clean Architecture**, powered by **BLoC/Cubit state management**, and fully functional offline.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ebe309e3-cd63-4437-b685-d955c7c3a42e" width="280">
</p>

---

## 🛠️ FEATURES (v1.0)

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

### 🎮 Relaxing Mini-Games
- **Breathing Exercise** — Guided 4-4-6-2 breathing cycle with animated circle, particle effects, and starfield background
- **Star Catcher** — Tap falling stars to collect points with increasing difficulty
- **Bubble Pop** — Physics-based bubble animations with haptic feedback
- **Sheep Counter** — Classic sleep-inducing sheep counting game
- **Sleep Films** — Curated collection of relaxation films with watch tracking

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

### ⚙️ Settings & Personalization
- 🇹🇷 Turkish / 🇬🇧 English language support
- Sleep reminder notifications
- Bedtime schedule and sleep goal configuration
- Dark theme by default

### 💬 Feedback System
- 5-star rating selector
- Detailed text feedback with submission to backend (API-ready)

---

## 🔄 UPCOMING FEATURES (v1.1+)

- ✅ Firebase Authentication integration (MockAuth → FirebaseAuth)
- 🔄 Backend API connection (sleep tips, AI story generator, chatbot)
- ✨ Real In-App Purchase implementation (Google Play Billing)
- 📈 Firebase Cloud Messaging push notifications
- 🤖 AI-powered music & story recommendations (LLM integration)
- 🔥 Firebase Analytics / telemetry
- 🍎 iOS platform testing & App Store publishing
- 🎮 Additional relaxing mini-games & content

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
│   ├── router/                        # GetX route definitions (20+ pages)
│   ├── theme/                         # Dark theme, color scheme, ThemeProvider
│   └── utils/                         # Extensions, SleepDurationCalculator
├── features/
│   ├── auth/                          # Authentication (Mock → Firebase ready)
│   │   ├── bloc/                      # AuthBloc, AuthEvent, AuthState
│   │   ├── data/                      # AuthRepository (mock implementation)
│   │   └── presentation/             # Splash, Login, Register, ForgotPassword
│   ├── dashboard/                     # Main hub with 4-tab navigation
│   ├── feedback/                      # User feedback (rating + message)
│   ├── games/                         # 5 mini-games + hub page
│   ├── learning/                      # Educational articles with search & filter
│   ├── level_system/                  # RPG progression (XP, quests, 99 levels)
│   ├── pro/                           # PRO subscription paywall (IAP)
│   ├── rewards/                       # Achievement badge system (12 badges)
│   ├── settings/                      # Language, notifications, sleep goal
│   ├── sleep_tracking/                # Sleep logging, charts, quality scoring
│   └── sounds/                        # Multi-track sound mixer (40+ sounds)
├── l10n/                              # ARB translation files (TR / EN)
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

**IN APP:**


<p align="center">
    <img src="https://github.com/user-attachments/assets/ebe309e3-cd63-4437-b685-d955c7c3a42e" width="280">
    <img src="https://github.com/user-attachments/assets/6ed4b275-c260-46be-948c-78bb5eb7aefd" width="280" alt="screenshot2">
    <img src="https://github.com/user-attachments/assets/411c3c6c-cfb1-4499-858c-e55adad3ddfb" width="280" alt="screenshot3">
  <img src="https://github.com/user-attachments/assets/bae68ebd-d64e-4e1e-8d2a-56994afa8e16" width="280" alt="screenshot4">
  <img src="https://github.com/user-attachments/assets/bbd517e9-a87e-4091-868f-0ef68f4c4dbd" width="280" alt="screenshot5">
  <img src="https://github.com/user-attachments/assets/386e60f4-bfe5-4478-8b58-a00a6a75bbcc" width="280" alt="screenshot6">
  <img src="https://github.com/user-attachments/assets/f51377c2-42b0-452e-a9ee-4c52e5d987f6" width="280" alt="screenshot7">
  
  
</p>

<p align="center">
  <b>🌙 SleepyApp</b> — Better sleep, better life.
</p>
