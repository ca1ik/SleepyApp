import 'package:get/get.dart';
import 'package:sleepy_ai/core/l10n/translations_de.dart';
import 'package:sleepy_ai/core/l10n/translations_es.dart';
import 'package:sleepy_ai/core/l10n/translations_fr.dart';
import 'package:sleepy_ai/core/l10n/translations_it.dart';
import 'package:sleepy_ai/core/l10n/translations_zh.dart';
import 'package:sleepy_ai/core/l10n/translations_ja.dart';
import 'package:sleepy_ai/core/l10n/translations_ko.dart';
import 'package:sleepy_ai/core/l10n/translations_ar.dart';
import 'package:sleepy_ai/core/l10n/translations_ru.dart';
import 'package:sleepy_ai/core/l10n/translations_pt.dart';
import 'package:sleepy_ai/core/l10n/translations_hi.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'tr': _tr,
        'de': translationsDe,
        'es': translationsEs,
        'fr': translationsFr,
        'it': translationsIt,
        'zh': translationsZh,
        'ja': translationsJa,
        'ko': translationsKo,
        'ar': translationsAr,
        'ru': translationsRu,
        'pt': translationsPt,
        'hi': translationsHi,
      };

  static const Map<String, String> _en = {
    // ── General ───────────────────────────────────────────────────────
    'appName': 'SleepyApp',
    'error': 'Error',
    'success': 'Success',
    'loading': 'Loading...',
    'retry': 'Retry',
    'back': 'Back',
    'cancel': 'Cancel',
    'ok': 'OK',
    'or': 'or',
    'save': 'Save',
    'submit': 'Submit',
    'send': 'Send',
    'hours': 'hours',
    'quest': 'quest',
    'done': 'done',

    // ── Auth ──────────────────────────────────────────────────────────
    'welcomeBack': 'Welcome Back! 🌙',
    'welcomeBackSub': 'Sign in for healthy sleep habits.',
    'emailLabel': 'Email',
    'emailRequired': 'Email is required',
    'emailInvalid': 'Enter a valid email',
    'passwordLabel': 'Password',
    'passwordRequired': 'Password is required',
    'passwordMin6': 'Password must be at least 6 characters',
    'passwordMin8': 'Password must be at least 8 characters',
    'passwordUppercase': 'Must contain at least one uppercase letter',
    'passwordDigit': 'Must contain at least one digit',
    'forgotPasswordQ': 'Forgot Password',
    'loginBtn': 'Login',
    'noAccount': "Don't have an account? ",
    'signUpBtn': 'Sign Up',
    'createAccount': 'Create Account ✨',
    'startJourney': 'Start your sleep journey today.',
    'fullNameLabel': 'Full Name',
    'fullNameRequired': 'Full name is required',
    'fullNameMin': 'Enter at least 2 characters',
    'confirmPasswordLabel': 'Confirm Password',
    'passwordsMismatch': 'Passwords do not match',
    'registerBtn': 'Sign Up',
    'registerError': 'Registration Error',
    'haveAccount': 'Already have an account? ',
    'signInBtn': 'Sign In',
    'resetPassword': 'Reset Password',
    'resetPasswordSub': 'We will send a password reset link to your email.',
    'emailSent': 'Email Sent',
    'resetEmailSent': 'Password reset link has been sent to your email.',
    'authUserNotFound': 'No user found with this email.',
    'authError': 'Authentication error: @code',

    // ── Nav / Tabs ────────────────────────────────────────────────────
    'home': 'Home',
    'sounds': 'Sounds',
    'learn': 'Learn',
    'hero': 'Hero',
    'profile': 'Profile',

    // ── Dashboard ─────────────────────────────────────────────────────
    'goodNight': 'Good Night',
    'goodMorning': 'Good Morning',
    'goodAfternoon': 'Good Afternoon',
    'goodEvening': 'Good Evening',
    'sleepScore': 'Sleep Score',
    'sleepExcellent': 'Excellent',
    'sleepGood': 'Good',
    'sleepFair': 'Fair',
    'sleepPoor': 'Poor',
    'weeklyAvg': 'Weekly Avg.',
    'sleepDebt': 'Sleep Debt',
    'trackingActive': 'Sleep tracking active 😴',
    'sleepScoreIs': 'Sleep score: @score/100',
    'trackBtn': 'Track',
    'quickAccess': 'Quick Access',
    'stories': 'Stories',
    'meditation': 'Meditation',
    'badges': 'Badges',
    'assistant': 'Assistant',
    'games': 'Games',
    'myBadges': 'My Badges',
    'seeAll': 'See All',
    'sleepTips': 'Sleep Tips',
    'more': 'More',
    'tipConsistentTitle': 'Consistent Sleep Schedule',
    'tipConsistentBody':
        'Going to bed and waking up at the same time every day regulates your circadian rhythm.',
    'tipScreenTitle': 'Avoid Screens',
    'tipScreenBody':
        'Stay away from phone and computer screens 1 hour before bedtime.',
    'tipCoolRoomTitle': 'Cool Room',
    'tipCoolRoomBody':
        'The ideal bedroom temperature is between 16-19 degrees Celsius.',

    // ── Sleep Tracking ────────────────────────────────────────────────
    'sleepTracking': 'Sleep Tracking',
    'sleepDataLoading': 'Loading sleep data...',
    'saved': 'Saved 🌙',
    'sleepRecordAdded': 'Sleep record added successfully.',
    'endSleep': 'End Sleep',
    'startSleep': 'Start Sleep',
    'addManualRecord': 'Add sleep record manually',
    'recentRecords': 'Recent Records',
    'addSleepRecord': 'Add Sleep Record',
    'bedtimeLabel': 'Bedtime',
    'wakeTimeLabel': 'Wake Time',
    'sleepQuality': 'Sleep Quality',
    'target': 'Target',
    'monthJan': 'Jan',
    'monthFeb': 'Feb',
    'monthMar': 'Mar',
    'monthApr': 'Apr',
    'monthMay': 'May',
    'monthJun': 'Jun',
    'monthJul': 'Jul',
    'monthAug': 'Aug',
    'monthSep': 'Sep',
    'monthOct': 'Oct',
    'monthNov': 'Nov',
    'monthDec': 'Dec',

    // ── Sounds ────────────────────────────────────────────────────────
    'soundsAndMusic': 'Sounds & Music 🎵',
    'soundLibrary': 'Sound Library',
    'aiMoodMusic': 'AI Mood Music',
    'catAll': 'All',
    'catNature': 'Nature',
    'catRain': 'Rain',
    'catWhiteNoise': 'Noise',
    'catAmbient': 'Ambient',
    'catMedieval': 'Medieval',
    'catLullaby': 'Lullaby',
    'catInstrument': 'Instrument',
    'catMeditation': 'Meditation',
    'catBinaural': 'Binaural',
    'catHappy': 'Happy',
    'catPrayer': 'Prayer',
    'catFavorites': 'Favorites',
    'aiMoodTitle': 'AI Mood Music',
    'aiMoodDesc': 'Describe your current mood or environment, '
        'and AI will create a custom sound mix for you.',
    'aiMoodHint': 'E.g. "I feel tired on a rainy evening..."',
    'askAi': 'Ask AI',
    'aiRecommendations': 'AI Recommendations',
    'soundsLoadError': 'Failed to load sounds: @e',

    // ── Sound names ───────────────────────────────────────────────────
    'soundHeavyRain': 'Heavy Rain',
    'soundLightRain': 'Light Rain',
    'soundWaterDrop': 'Water Drop',
    'soundOceanWaves': 'Ocean Waves',
    'soundForestBirds': 'Forest Birds',
    'soundWaterfall': 'Waterfall',
    'soundThunder': 'Thunder',
    'soundWind': 'Wind',
    'soundWhiteNoise': 'White Noise',
    'soundBrownNoise': 'Brown Noise',
    'soundPinkNoise': 'Pink Noise',
    'soundFan': 'Fan',
    'soundCafeAmbiance': 'Cafe Ambiance',
    'soundFireplace': 'Fireplace',
    'soundLibraryAmbiance': 'Library',
    'soundTrain': 'Train',
    'soundMedievalTavern': 'Medieval Tavern',
    'soundMedievalLute': 'Medieval Lute',
    'soundMedievalForest': 'Medieval Forest',
    'soundClassicLullaby': 'Classic Lullaby',
    'soundLullabyMelody': 'Lullaby Melody',
    'soundSoftPiano': 'Soft Piano',
    'soundAcousticGuitar': 'Acoustic Guitar',
    'soundTibetanBowl': 'Tibetan Bowl',
    'soundPeacefulFlute': 'Peaceful Flute',
    'soundOmMeditation': 'Om Meditation',
    'soundBinauralDelta': 'Binaural Delta (Deep sleep)',
    'soundBinauralTheta': 'Binaural Theta (Dream)',
    'soundJoyBirds': 'Joy Birds',
    'soundWindChime': 'Wind Chime',
    'soundCatPurr': 'Cat Purr',
    'soundPrayerAmbiance': 'Prayer Ambiance',

    // ── Learning ──────────────────────────────────────────────────────
    'sleepGuide': 'Sleep Guide 📖',
    'searchArticles': 'Search articles...',
    'noArticles': 'No articles found.',
    'min': 'min',
    'catBiology': 'Biology',
    'catTechnology': 'Technology',
    'catNutrition': 'Nutrition',
    'catEnvironment': 'Environment',
    'catTechnique': 'Technique',
    'catSports': 'Sports',
    'catPsychology': 'Psychology',
    'catHygiene': 'Hygiene',
    'articleCircadian': 'What is Circadian Rhythm?',
    'articleCircadianBody':
        'Everything about your internal clock that governs your sleep-wake cycle.',
    'articleScreen': 'Screen Cave Syndrome',
    'articleScreenBody':
        'How blue light affects sleep and how to protect yourself.',
    'articleDeepSleep': 'Deep Sleep Stages',
    'articleDeepSleepBody':
        'What does the brain do during REM and NREM sleep stages?',
    'articleCaffeine': 'Caffeine and Sleep',
    'articleCaffeineBody': 'When should you cut caffeine? What is half-life?',
    'articleCoolRoom': 'Sleep Better in a Cool Room',
    'articleCoolRoomBody': 'How to set the ideal bedroom temperature.',
    'articleBreathing': '4-7-8 Breathing Technique',
    'articleBreathingBody':
        'A powerful technique that helps you fall asleep in minutes.',
    'articleExercise': 'Exercise and Sleep Quality',
    'articleExerciseBody':
        'Which type of workout boosts sleep quality the most?',
    'articleStress': 'Stress: The Sleep Enemy',
    'articleStressBody': 'How cortisol levels negatively affect sleep?',
    'articleMelatonin': 'Melatonin Supplement',
    'articleMelatoninBody':
        'When and how to use melatonin? Ways to increase natural production.',
    'articleHygiene': 'Sleep Hygiene 101',
    'articleHygieneBody': 'The fundamental rules of healthy sleep habits.',
    'articlePowerNap': 'The Science of Power Naps',
    'articlePowerNapBody': 'Why is a 20-minute nap so effective?',
    'articleChronotype': 'Personal Sleep Profile',
    'articleChronotypeBody':
        'Are you a morning person or a night owl? Discover your chronotype.',

    // ── Rewards ───────────────────────────────────────────────────────
    'myBadgesTitle': 'My Badges',
    'noBadgesYet':
        'No badges earned yet.\nKeep sleeping well to unlock badges!',
    'locked': 'Locked',
    'lockedCount': 'Locked (@count)',
    'yourSleepScore': 'Your Sleep Score',
    'earned': '✓ Earned',
    'earnedCount': 'Earned (@count)',
    'scoreLabel': 'Score: @score+',

    // ── Feedback ──────────────────────────────────────────────────────
    'feedback': 'Feedback',
    'howWasApp': 'How was SleepyApp?',
    'feedbackHelper': 'Your feedback helps us improve the app.',
    'yourRating': 'Your Rating',
    'feedbackPlaceholder': 'Share your thoughts... (optional)',
    'submitting': 'Submitting...',
    'thankYou': 'Thank You! 🙏',
    'feedbackSent': 'Your feedback was submitted successfully.',
    'anErrorOccurred': 'An error occurred.',
    'ratingVeryBad': 'Very Bad 😞',
    'ratingBad': 'Bad 😕',
    'ratingAverage': 'Average 😐',
    'ratingGood': 'Good 😊',
    'ratingExcellent': 'Excellent! 🤩',

    // ── Settings ──────────────────────────────────────────────────────
    'settings': 'Settings',
    'themeSection': 'APPEARANCE',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'languageSection': 'Language',
    'turkish': 'Türkçe',
    'english': 'English',
    'notifications': 'Notifications',
    'sleepReminder': 'Sleep Reminder',
    'sleepReminderSub': 'Get notified at bedtime',
    'sleepSchedule': 'Sleep Schedule',
    'bedtime': 'Bedtime',
    'sleepGoal': 'Sleep Goal',
    'account': 'Account',
    'privacyPolicy': 'Privacy Policy',
    'termsOfService': 'Terms of Service',
    'logout': 'Logout',
    'logoutConfirm': 'Are you sure you want to logout?',

    // ── PRO ───────────────────────────────────────────────────────────
    'proWelcome': '🎉 Welcome to PRO! All features unlocked.',
    'purchaseFailed': 'Purchase failed.',
    'proPremiumExp': 'Premium experience for better sleep',
    'proWhatYouGet': 'What do you get with PRO?',
    'monthlyPlan': 'Monthly Plan',
    'monthlyLabel': 'per month',
    'yearlyPlan': 'Yearly Plan',
    'yearlyLabel': 'per year (33% off)',
    'bestValue': 'BEST VALUE',
    'restorePurchases': 'Restore Purchases',
    'subscriptionNote': 'Subscription renews automatically. Cancel anytime.',
    'proSleepyAssistant': 'Sleepy Assistant',
    'proAssistantDesc': 'AI-powered personal sleep consultant',
    'proUnlimitedSounds': 'Unlimited Sounds & Mixer',
    'proUnlimitedSoundsDesc': 'Up to 6 simultaneous sound layers',
    'proAiMoodMusic': 'AI Mood Music',
    'proAiMoodMusicDesc': 'Personalized music based on your mood',
    'proAllContent': 'All Content',
    'proAllContentDesc': 'All sleep guide articles',
    'proSmartAlarm': 'Smart Alarm',
    'proSmartAlarmDesc': 'Wake up alarm based on sleep cycles',
    'proAdvancedAnalysis': 'Advanced Analysis',
    'proAdvancedAnalysisDesc': 'Detailed sleep charts and reports',
    'proSpecialBadges': 'Special Badges',
    'proSpecialBadgesDesc': 'Exclusive rewards for PRO members',
    'proCloudSync': 'Cloud Sync',
    'proCloudSyncDesc': 'Cross-device sleep data synchronization',
    'goPro': '✨ Go PRO',

    // ── Sleepy Assistant ──────────────────────────────────────────────
    'aiSleepConsultant': 'AI-powered sleep consultant',
    'assistantGreeting':
        'Hello! I\'m Sleepy Assistant 🌙\n\nI\'m ready to answer your questions about sleep issues, sleep routines, or tips for better rest.\n\nHow can I help you?',
    'proGateDesc':
        'Become a PRO member to access your AI-powered personal sleep consultant.',
    'proGateFeature1': 'Personalized advice for your sleep issues',
    'proGateFeature2': 'Meditation and breathing technique guidance',
    'proGateFeature3': 'Sleep routine building support',
    'askAboutSleep': 'Ask something about sleep…',

    // ── Assistant Responses ───────────────────────────────────────────
    'respSleepHours':
        'Adults are recommended to sleep **7-9 hours** each night.\n\n'
            'Going to bed and waking up at the same time every day regulates your body\'s biological clock. '
            'Try not to deviate from this routine even on weekends. ⏰',
    'respSleepProblems': 'Here are some tips for sleep issues:\n\n'
        '• **Consistent schedule:** Go to bed and wake up at the same time every day.\n'
        '• **Bedroom:** Keep it dark, cool (16–19°C), and quiet.\n'
        '• **Screen time:** Put away your phone/computer 1 hour before bed.\n'
        '• **Caffeine:** Reduce coffee/tea consumption after noon. ☕\n\n'
        'If problems persist, I recommend consulting a doctor.',
    'respMeditation': '**4-7-8 Breathing Technique** works great before sleep:\n\n'
        '1. Inhale through your nose for 4 seconds.\n'
        '2. Hold your breath for 7 seconds.\n'
        '3. Exhale slowly through your mouth for 8 seconds.\n\n'
        'Repeating this 3-4 times activates your parasympathetic nervous system and calms your mind. 🧘',
    'respDreams': 'Dreams usually occur during **REM sleep**.\n\n'
        '• To have vivid dreams, try increasing vitamin B6 intake (banana, avocado).\n'
        '• Frequent nightmares may signal stress or sleep irregularity.\n'
        '• Keeping a dream journal helps you remember your dreams. 📓',
    'respAlarm': 'To wake up refreshed, calculate your sleep cycles:\n\n'
        'One sleep cycle is approximately **90 minutes**. '
        'Try waking up after 4.5, 6, 7.5, or 9 hours of sleep.\n\n'
        'A sunrise alarm or sunlight simulator also makes waking easier. 🌅',
    'respEnvironment': 'For an ideal sleep environment:\n\n'
        '🌡️ **Temperature:** 16–19°C is optimal.\n'
        '🌑 **Light:** Completely dark or use a sleep mask.\n'
        '🔇 **Sound:** White noise or SleepyApp\'s ambient sounds.\n'
        '🛏️ **Bed:** Quality mattress and pillow significantly improve sleep quality.',
    'respNutrition': 'Sleep and nutrition:\n\n'
        '☕ **Caffeine:** Cut it 6 hours before bed.\n'
        '🍷 **Alcohol:** Reduces sleep quality; disrupts REM sleep.\n'
        '🍽️ **Heavy meals:** Eat something light 2-3 hours before bed.\n'
        '🍌 **Magnesium & Tryptophan:** Banana, almond, milk—natural sleep supporters.',
    'respExercise': 'Exercise improves sleep quality, but timing matters:\n\n'
        '✅ Morning or noon exercise is ideal.\n'
        '⚠️ Avoid intense exercise within 3 hours of bedtime; '
        'it raises cortisol and body temperature.\n'
        '🧘 Yoga or light stretching before bed is great! 🌙',
    'respHygiene': 'Golden sleep hygiene rules:\n\n'
        '1. 📱 Turn off screens 1 hour before bed.\n'
        '2. 🛁 A warm shower supports circadian rhythm.\n'
        '3. 📚 Do light reading or meditation.\n'
        '4. ☕ No caffeine after noon.\n'
        '5. 🌡️ Set room temperature to 16–19°C.\n'
        '6. ⏰ Go to bed and wake up at the same time every day.',
    'respGreeting': 'Hello! 🌙 I\'m Sleepy Assistant.\n\n'
        'I\'m ready to answer questions about your sleep health. '
        'What would you like to learn about sleep duration, routines, meditation, or sleep environment?',
    'respThanks': 'You\'re welcome! 😊\n\n'
        'I\'m here if you have more questions about better sleep. '
        'Good night and sweet dreams. 🌙✨',
    'respDefault': 'Here\'s what I can say about that:\n\n'
        'Quality sleep is a cornerstone of physical and mental health. '
        'Regular sleep schedules, a relaxing environment, and stress management '
        'can significantly improve your sleep quality. 🌙\n\n'
        'Would you like me to help with something more specific? '
        'For example: you can ask about *sleep duration*, *meditation techniques*, *sleep routine*, or *sleep environment*.',

    // ── Daily Limit & Pro Sound Dialogs ───────────────────────────────
    'dailyLimitTitle': 'Daily Limit Reached',
    'dailyLimitDesc':
        'Free users can use the AI assistant once per day. Upgrade to PRO for unlimited access! 🌙',
    'dailyLimitBanner':
        'You\'ve used your free daily message. Upgrade for unlimited access.',
    'proSoundTitle': 'PRO Sound',
    'proSoundDesc':
        'This sound is available for PRO members. Upgrade to unlock all premium sounds! 🎵',

    // ── Level System ──────────────────────────────────────────────────
    'levelTitle1': 'Sleeping Seed',
    'levelTitle2': 'Dream Bud',
    'levelTitle3': 'Star Traveler',
    'levelTitle4': 'Moon Guardian',
    'levelTitle5': 'Dream Weaver',
    'levelTitle6': 'Night Explorer',
    'levelTitle7': 'Sleep Master',
    'levelTitle8': 'Dream Architect',
    'levelTitle9': 'Lord of the Night',
    'levelTitle10': 'Sleep God',
    'levelTitle11': 'Eternal Dream',
    'levelSub': 'Level @level  •  Sleep Hero',
    'dayStreak': '@days-day streak!',
    'newTitleEarned': '✨  New Title Earned',
    'proContinue': 'Continue with PRO',
    'proReachLv99': '✨ Reach Lv.99 with PRO!',
    'nextLv': 'Next: Lv.@level',
    'lv6ProRequired': 'PRO required for Lv.6',
    'maxLevelReached': 'Maximum Level Reached!',
    'dailyQuestsTitle': '📅  Daily Quests',
    'levelPath': '🗺️  Level Path',
    'myHero': '📊  My Hero',
    'totalXpLabel': 'Total XP',
    'streakLabel': 'Streak',
    'activeDaysLabel': 'Active Days',
    'levelUpTitle': 'LEVEL UP!',
    'levelUpSub': 'Level @old  →  Level @new',
    'levelUpContinue': 'Awesome!  Continue  ✨',
    'proButtonSmall': 'GO PRO',
    'streakDays': '@days Days',

    // ── Daily Quests ──────────────────────────────────────────────────
    'questDailyLogin': 'Daily Login',
    'questDailyLoginDesc': 'Open the app every day',
    'questSleepTracking': 'Sleep Tracking',
    'questSleepTrackingDesc': 'Start sleep tracking tonight',
    'questSleepSound': 'Sleep Sound',
    'questSleepSoundDesc': 'Listen to sleep sounds for 10 minutes',
    'questMiniGame': 'Mini Game',
    'questMiniGameDesc': 'Play a sleep game',
    'questSleepSchool': 'Sleep School',
    'questSleepSchoolDesc': 'Visit the sleep knowledge section',

    // ── Games Hub ─────────────────────────────────────────────────────
    'sleepFilms': '🎬 Sleep Films',
    'spaceGamesAndFilms': 'Space Games & Films',
    'playWatchExplore': 'Play, watch, and explore to relax',
    'totalGameScore': 'Total Game Score',
    'watchedFilms': 'Watched Films',
    'gamesTab': '🎮 Games',
    'filmsTab': '🎬 Sleep Films',
    'gameBadgesTab': '🏆 Game Badges',
    'cosmicBreath': 'Cosmic Breath',
    'cosmicBreathDesc': '4-4-6-2 breathing technique • Reduces stress',
    'starCatcher': 'Star Catcher',
    'starCatcherDesc': 'Catch falling stars • 90 seconds',
    'balloonGarden': 'Balloon Garden',
    'balloonGardenDesc': '3 minutes • Pop slowly • Stress-free',
    'sheepCounting': 'Sheep Counting',
    'sheepCountingDesc': 'Classic sleep ritual • Very calm',
    'sleepFilmsTitle': 'Sleep Films',
    'filmsAnimDesc': '8 animations • Space, ocean, aurora and more',
    'gameBadgesPlay': 'Earn badges by playing games and watching films!',
    'playBtn': 'Play →',

    // ── Breathing Game ────────────────────────────────────────────────
    'phaseInhale': 'Inhale',
    'phaseHold': 'Hold',
    'phaseExhale': 'Exhale',
    'phaseRest': 'Rest',
    'cyclesProgress': 'Cycle @current / @total',
    'cosmicBreathIntro':
        'Breathe with the universe using the 4-4-6-2 technique.\nEarn 500 points in 10 cycles.',
    'startCosmicBreath': '🌌  Start',
    'awesome': 'Awesome!',
    'cyclesCompleted': '@cycles cycles completed',
    'points': 'POINTS',
    'cosmicBreathBadge': '"Cosmic Breath" badge earned!',
    'playAgain': 'Play Again',
    'backToGames': 'Back to Games',

    // ── Sheep Counter ─────────────────────────────────────────────────
    'sheepTitle': 'Sheep Counting',
    'sleepTime': 'Sleep time… 💤',
    'countedSheepFooter': 'sheep counted 🐑',
    'sheepMoreForBadge': '@count more sheep for badge →  🏅',
    'badgeEnough': 'Enough for the badge! 🎉',
    'sheepCounted': 'Sheep Counted',
    'score': 'Score',
    'badgeThreshold': 'Badge Threshold',
    'thirtySheep': '30 sheep',
    'badgeEarned': 'Badge Earned!',
    'sleepySheep': 'Sleepy Sheep',
    'again': 'Again',

    // ── Bubble Pop ────────────────────────────────────────────────────
    'balloonCountLabel': 'BALLOON',
    'goalLabel': 'GOAL',
    'secondsLeft': '@sec sec',
    'tapBubbles': 'Tap and pop the bubbles 🫧',
    'balloonGardenTitle': 'Balloon Garden',
    'sessionOver': 'Session Over!',
    'poppedBalloons': 'Popped Balloons',
    'fiftyBalloons': '50 balloons',
    'balloonPopper': 'Balloon Popper',

    // ── Star Catcher ──────────────────────────────────────────────────
    'starCatcherTitle': 'Star Catcher',
    'gameOver': 'Game Over!',
    'caughtLabel': 'CAUGHT',
    'tapStars': 'Tap the stars and catch them!',
    'caughtStars': 'Caught Stars',
    'targetScore': 'Target score',
    'threeHundredPoints': '300 points',
    'starCatcherBadge': 'Star Catcher',

    // ── Sleep Films ───────────────────────────────────────────────────
    'filmCompleted': 'Film completed ✨',
    'swipeForNext': 'Swipe right for next scene →',
    'sceneLabel': 'Scene @current/@total',
    'minutesShort': '~3 min',
    'dreamWeaver': 'Dream Weaver',
    'filmList': 'Film List',
    'sleepFilmsAppbar': 'Sleep Films',
    'filmsCount': '@count soothing animations • 2-3 minutes',

    // ── Sleep Chart ───────────────────────────────────────────────────
    'chartMon': 'Mon',
    'chartTue': 'Tue',
    'chartWed': 'Wed',
    'chartThu': 'Thu',
    'chartFri': 'Fri',
    'chartSat': 'Sat',
    'chartSun': 'Sun',
    'hoursShort': 'h',
    'targetHoursLabel': 'Target @hours h',

    // Film titles & subtitles
    'filmStarJourney': 'Star Journey',
    'filmStarJourneySub': 'Be a galaxy rider',
    'filmNebula': 'Nebula Garden',
    'filmNebulaSub': 'Where colors dance',
    'filmMoon': 'To the Moon',
    'filmMoonSub': 'Glide in the moonlight',
    'filmAurora': 'Aurora',
    'filmAuroraSub': 'Get lost in the northern lights',
    'filmOcean': 'Ocean Depths',
    'filmOceanSub': 'Bioluminescent world',
    'filmClouds': 'Cloud Surfing',
    'filmCloudsSub': 'Glide on pink clouds',
    'filmCrystal': 'Crystal Forest',
    'filmCrystalSub': 'Dance of light and crystals',
    'filmVoid': 'Infinite Space',
    'filmVoidSub': 'Deep meditation journey',

    // Film narrations – Star Journey
    'filmStar1':
        'You are gliding through the depths of dark space. Hundreds of stars are dancing with you.',
    'filmStar2':
        'Passing through nebulae, colorful lights embrace you. With each breath, you feel lighter.',
    'filmStar3':
        'The shimmer of distant galaxies invites you to peace. Your mind calms, your body relaxes.',
    'filmStar4':
        'You are a small but precious part of the universe\'s infinity. Enjoy this moment.',
    // Film narrations – Nebula Garden
    'filmNebula1':
        'Red, purple, and orange clouds slowly blend together. Nature\'s art of painting.',
    'filmNebula2':
        'New stars are born between gas clouds. With each breath, you too are reborn.',
    'filmNebula3':
        'Color waves slow your mind. Your body grows heavy, your eyes want to close.',
    'filmNebula4':
        'All colors merge into a single white light. Peace embraces you like this light.',
    // Film narrations – Moon
    'filmMoon1':
        'The crescent moon slowly grows. The moon\'s cool light touches your face, your heart calms.',
    'filmMoon2':
        'You notice the craters on the moon\'s surface. Each crater is a memory, each mark a story.',
    'filmMoon3':
        'The moon\'s gravity pulls you gently. No weight, just a slow dance.',
    'filmMoon4':
        'Earth is a tiny blue dot from afar. In this silence, there is only breath.',
    // Film narrations – Aurora
    'filmAurora1':
        'Green and blue bands dance across the sky. The northern lights whisper something to you.',
    'filmAurora2':
        'Light waves vibrate rhythmically. This rhythm softens your breathing pace.',
    'filmAurora3':
        'Purple and pink tones blend into green. The sky looks like a living painting.',
    'filmAurora4':
        'The lights slowly fade. The night embraces you, sleep is knocking at the door.',
    // Film narrations – Ocean
    'filmOcean1':
        'As you descend deeper, the blue darkens. You glide like a jellyfish.',
    'filmOcean2':
        'Bioluminescent fish dance around you. Even in darkness, there is light.',
    'filmOcean3':
        'The ocean current carries you. Letting go of control can be this beautiful.',
    'filmOcean4':
        'The silence of the deep seeps into your brain. The rhythm of waves becomes a sleep rhythm.',
    // Film narrations – Clouds
    'filmCloud1':
        'You are walking on pink and orange clouds. Soft as cotton, a light feeling.',
    'filmCloud2':
        'Sunbeams filter through the clouds. Each beam brings warmth and peace.',
    'filmCloud3':
        'The wind gently carries you forward. Gliding on clouds feels like sleeping.',
    'filmCloud4':
        'Sunset colors fade. Night slowly drapes, sleep welcomes you.',
    // Film narrations – Crystal
    'filmCrystal1':
        'Giant crystals burst from the cave walls. Each one refracts a thousand colors.',
    'filmCrystal2':
        'Light dances inside the crystals. Rainbow colors adorn the ceiling.',
    'filmCrystal3':
        'When you touch the crystals, you feel a sweet vibration. The brain calms at this frequency.',
    'filmCrystal4':
        'All crystals light up at once, then dim. This rhythm is your very breathing rhythm.',
    // Film narrations – Void
    'filmVoid1':
        'Complete darkness. Only breath exists. This darkness is not scary, it\'s soothing.',
    'filmVoid2':
        'There is a small light in the distance. You slowly move toward it. No rush.',
    'filmVoid3':
        'The light grows, turning into a star. You feel its warmth, your mind becomes still.',
    'filmVoid4':
        'Everything is fine. You are safe. You are in the right place to rest. Sleep is very close now.',

    // ── Badge Names ───────────────────────────────────────────────────
    'badgeCosmicBreath': 'Cosmic Breath',
    'badgeStarCatcher': 'Star Catcher',
    'badgeDreamWeaver': 'Dream Weaver',
    'badgeGalaxyTraveler': 'Galaxy Traveler',
    'badgeSleepWise': 'Sleep Wise',
    'badgeBalloonPopper': 'Balloon Popper',
    'badgeSleepySheep': 'Sleepy Sheep',

    // ── Earned Badge Display ──────────────────────────────────────────
    'earnedBadge': 'Earned ✓',

    // ── Chart ─────────────────────────────────────────────────────────
    'dayMon': 'Mon',
    'dayTue': 'Tue',
    'dayWed': 'Wed',
    'dayThu': 'Thu',
    'dayFri': 'Fri',
    'daySat': 'Sat',
    'daySun': 'Sun',

    // ── Error messages ────────────────────────────────────────────────
    'errNoInternet': 'No internet connection.',
    'errCacheRead': 'Local data read error.',
    'errSessionExpired': 'Your session has expired. Please log in again.',
    'errUnexpected': 'An unexpected error occurred. Please try again.',
    'errTimeout': 'Connection timed out. Try again.',
    'errCertificate': 'Secure connection could not be established.',
    'errCancelled': 'Request cancelled.',
    'errInvalidRequest': 'Invalid request.',
    'errNoAccess': 'You do not have access to this resource.',
    'errNotFound': 'Resource not found.',
    'errValidation': 'Data validation error.',
    'errTooMany': 'Too many requests. Please wait.',
    'errServer': 'Server error (@code).',
    'errSleepHistoryLoad': 'Failed to load sleep history: @e',
    'errRecordSave': 'Failed to save record: @e',
    'errRecordDelete': 'Failed to delete record: @e',

    // ── New Games ─────────────────────────────────────────────────────
    'game_dream_labyrinth': 'Dream Labyrinth',
    'game_dream_labyrinth_desc':
        'Navigate a dreamy maze and collect moon fragments.',
    'game_moon_runner': 'Moon Runner',
    'game_moon_runner_desc':
        'Run across the lunar surface, dodge craters, collect stars.',
    'game_nebula_match': 'Nebula Match',
    'game_nebula_match_desc': 'Flip cosmic cards and find matching pairs.',
    'game_galaxy_puzzle': 'Galaxy Puzzle',
    'game_galaxy_puzzle_desc': 'Slide tiles to restore the cosmic image.',
    'game_cosmic_flow': 'Cosmic Flow',
    'game_cosmic_flow_desc':
        'Tap energy nodes in rhythm as the cosmos slows you to sleep.',
    'moons': 'Moons',
    'moves': 'Moves',
    'time': 'Time',
    'game_won': 'You Won! 🎉',
    'streak': 'Streak',
    'level': 'Level',
    'bpm': 'BPM',
    'best': 'Best',
    'start': 'Start',
    'lanes': 'Lanes',
    'game_over': 'Game Over',
    'play_again': 'Play Again',
    'pairs_found': 'Pairs Found',
    'puzzle_complete': 'Puzzle Complete!',

    // ── Zodiac & Astral ───────────────────────────────────────────────
    'zodiac_hub': 'Zodiac & Astral',
    'zodiac_hub_desc': 'Explore your zodiac sign and astral exercises.',
    'daily_horoscope': 'Daily Horoscope',
    'compatibility': 'Compatibility',
    'astral_exercises': 'Astral Exercises',
    'zodiac_detail': 'Zodiac Detail',
    'zodiac_compatibility': 'Zodiac Compatibility',
    'your_sign': 'Your Sign',
    'select_sign': 'Select Sign',
    'partner_sign': 'Partner Sign',
    'love': 'Love',
    'friendship': 'Friendship',
    'sleep_harmony': 'Sleep Harmony',
    'astral_connection': 'Astral Connection',
    'overall': 'Overall',
    'all_compatibilities': 'All Compatibilities',
    'set_birthday': 'Set Birthday',
    'element': 'Element',
    'modality': 'Modality',
    'sleep_profile': 'Sleep Profile',
    'astral_advice': 'Astral Advice',
    'sign_traits': 'Traits',
    'exercise_steps': 'Steps',
    'begin_exercise': 'Begin Exercise',
    'breathe_in': 'Breathe In',
    'breathe_out': 'Breathe Out',
    'hold': 'Hold',
    'step_n': 'Step @n',
    'duration_min': '@n min',
    'difficulty': 'Difficulty',
    'category': 'Category',
    'beginner': 'Beginner',
    'intermediate': 'Intermediate',
    'advanced': 'Advanced',

    // ── Zodiac Signs ──────────────────────────────────────────────────
    'zodiac_aries': 'Aries',
    'zodiac_taurus': 'Taurus',
    'zodiac_gemini': 'Gemini',
    'zodiac_cancer': 'Cancer',
    'zodiac_leo': 'Leo',
    'zodiac_virgo': 'Virgo',
    'zodiac_libra': 'Libra',
    'zodiac_scorpio': 'Scorpio',
    'zodiac_sagittarius': 'Sagittarius',
    'zodiac_capricorn': 'Capricorn',
    'zodiac_aquarius': 'Aquarius',
    'zodiac_pisces': 'Pisces',

    // ── Astral Exercise Titles ────────────────────────────────────────
    'astral_projection': 'Astral Projection',
    'lucid_dreaming': 'Lucid Dreaming',
    'chakra_alignment': 'Chakra Alignment',
    'cosmic_energy_meditation': 'Cosmic Energy Meditation',
    'third_eye_activation': 'Third Eye Activation',

    // ── Sleep Stories ─────────────────────────────────────────────────
    'sleepStories': 'Sleep Stories',
    'storiesSubtitle': 'Magical tales to guide you to sleep',
    'scenes': 'scenes',
    'storyRedTitle': 'Red Riding Hood',
    'storyRedSub': 'A magical walk through the moonlit forest',
    'storyRed01':
        'Once upon a time, a little girl in a red hood set out through the forest as the moon rose above the trees...',
    'storyRed02':
        'Her gas lamp cast a warm golden glow on the path. The trees whispered ancient lullabies as she walked deeper into the woods...',
    'storyRed03':
        'She stopped for a moment to watch the fireflies dance among the ferns. Their tiny lights blinked like fallen stars...',
    'storyRed04':
        'The soft forest floor cushioned her steps. An owl hooted gently from a high branch, welcoming her to the night...',
    'storyRed05':
        'She came upon a clearing where mushrooms glowed with a faint blue light. The moon shone like a silver coin overhead...',
    'storyRed06':
        'A gentle breeze carried the scent of pine and wildflowers. She felt peace wrapping around her like a warm blanket...',
    'storyRed07':
        'The forest grew quieter now, as if nature itself was settling down to sleep. Even the wind began to whisper more softly...',
    'storyRed08':
        'She found a cozy spot beneath the oldest tree, sat down, and let her lamp dim. The stars sang her a silent lullaby as her eyes gently closed...',

    'storyMoonTitle': 'The Moon Princess',
    'storyMoonSub': 'A celestial journey across silver meadows',
    'storyMoon01':
        'High above the clouds, a princess made of moonlight stepped onto a bridge of silver stardust...',
    'storyMoon02':
        'Her lamp was the moon itself, tiny and radiant in her hand. Each step left a trail of soft white light on the path...',
    'storyMoon03':
        'She gazed across the endless meadow of star-flowers, each petal glowing with a gentle purple hue...',
    'storyMoon04':
        'The night breeze sang a melody only she could hear, weaving through constellations like a silk ribbon...',
    'storyMoon05':
        'She paused at the edge of a celestial lake, its surface reflecting a thousand sleeping galaxies...',
    'storyMoon06':
        'The princess lay down on a cloud of moonbeams, and the universe gently rocked her to sleep...',

    'storyStarTitle': 'The Star Collector',
    'storyStarSub': 'Gathering fallen stars in the quiet night',
    'storyStar01':
        'Every night, a young dreamer walks the hilltops with a lantern, searching for stars that have fallen from the sky...',
    'storyStar02':
        'Tonight the sky was generous. A golden star lay nestled in the grass, still warm and humming softly...',
    'storyStar03':
        'The dreamer picked it up gently and watched it pulse with light. Each star held a sleeping wish inside...',
    'storyStar04':
        'Walking further along the ridge, more stars dotted the meadow like glowing dewdrops in the darkness...',
    'storyStar05':
        'With pockets full of starlight, the dreamer sat on the hillcrest and watched the Milky Way breathe slowly...',
    'storyStar06':
        'One by one, the collected stars floated up and returned home. The dreamer smiled and drifted into a golden sleep...',

    'storyGnomeTitle': 'The Forest Gnome',
    'storyGnomeSub': 'A tiny guardian\'s nighttime patrol',
    'storyGnome01':
        'Deep in the enchanted woods, a little gnome with a mushroom hat began his nightly walk among the ancient trees...',
    'storyGnome02':
        'His green lantern hummed as he checked on sleeping flowers and tucked moss blankets around tiny forest creatures...',
    'storyGnome03':
        'He stopped by a babbling brook, its water singing a song as old as the mountains themselves...',
    'storyGnome04':
        'Fireflies gathered around him like old friends, their glow turning the forest into a living fairy tale...',
    'storyGnome05':
        'The gnome sat on a toadstool and played a tiny flute. The melody floated through the trees like warm honey...',
    'storyGnome06':
        'As the forest fell completely silent, the gnome curled up inside a hollow log, his lantern dimming to a soft ember...',

    'storyOceanTitle': 'Ocean Dream',
    'storyOceanSub': 'Drifting through bioluminescent waters',
    'storyOcean01':
        'Beneath the waves, where sunlight never reaches, a gentle swimmer drifted through a world of living light...',
    'storyOcean02':
        'Jellyfish floated past like glowing lanterns, trailing ribbons of soft cyan and violet through the deep...',
    'storyOcean03':
        'The swimmer paused to watch a giant sea turtle glide silently through a cathedral of coral...',
    'storyOcean04':
        'Tiny fish swirled around in spirals, their scales catching the bioluminescent glow like scattered diamonds...',
    'storyOcean05':
        'A whale sang in the distance, its deep voice vibrating through the water like a cosmic lullaby...',
    'storyOcean06':
        'The swimmer floated down to a bed of soft sea grass, wrapped in the ocean\'s gentle rocking, and fell asleep...',

    // ── No Ads / Subscription ────────────────────────────────────────
    'noAdsTitle': 'No Ads',
    'noAdsSubtitle': 'Enjoy uninterrupted sleep experience',
    'noAdsMonthlyPlan': 'No Ads Plan',
    'noAdsMonthlyLabel': 'Remove all ads — monthly subscription',
    'noAdsActivated': '🎉 Ads removed! Enjoy your clean experience.',
    'noAdsBenefit1': 'No Advertisements',
    'noAdsBenefit1Desc': 'Completely ad-free experience across the app',
    'noAdsBenefit2': 'Faster Experience',
    'noAdsBenefit2Desc': 'No waiting for ads, instant access to everything',
    'noAdsBenefit3': 'Peaceful Sleep',
    'noAdsBenefit3Desc': 'Focus on your sleep without distractions',
    'noAdsUpgradePro': 'Upgrade to PRO instead',
    'noAdsUpgradeProDesc': 'All PRO features + No Ads included',
    'noAdsProActive': 'PRO Member — No Ads Active',
    'noAdsProActiveDesc':
        'Ad-free experience included with your PRO membership',
    'noAdsSubscriptionNote':
        '₺49.99/month. Subscription renews automatically. Cancel anytime.',
    'noAdsActiveDesc': 'Ad-free experience active',
    'noAdsInactiveDesc': '₺49.99/month — Remove all ads',
    'adPlaceholder': 'Advertisement',
    'removeAdsHint': 'Tap to remove ads',
    'removeAds': 'Remove Ads',
    'subscriptionSection': 'Subscription',
    'proActive': 'PRO Active',
    'proActiveDesc': 'All premium features unlocked',
    'proInactiveDesc': 'Unlock all premium features',

    // ── Dream Journal ──────────────────────────────────────────────────
    'dreamJournal': 'Dream Journal',
    'dreamJournalTitle': 'Dream Journal',
    'dreamJournalEmpty': 'No dreams logged yet.\nStart recording your dreams!',
    'dreamTotal': 'Total',
    'dreamLucid': 'Lucid',
    'dreamRecurring': 'Recurring',
    'dreamAddTitle': 'Record Dream',
    'dreamTitleHint': 'Dream title...',
    'dreamDescHint': 'Describe your dream...',
    'dreamEmotions': 'Emotions',
    'dreamLucidity': 'Lucidity',
    'dreamIsRecurring': 'Recurring dream',
    'dreamSave': 'Save Dream',
    'dreamEmotionHappy': 'Happy',
    'dreamEmotionScared': 'Scared',
    'dreamEmotionPeaceful': 'Peaceful',
    'dreamEmotionConfused': 'Confused',
    'dreamEmotionExcited': 'Excited',
    'dreamEmotionSad': 'Sad',
    'dreamEmotionAnxious': 'Anxious',
    'dreamEmotionNostalgic': 'Nostalgic',
    'all': 'All',

    // ── Mood Tracker ───────────────────────────────────────────────────
    'moodTracker': 'Mood',
    'moodTrackerTitle': 'Mood Tracker',
    'moodTerrible': 'Terrible',
    'moodBad': 'Bad',
    'moodNeutral': 'Neutral',
    'moodGood': 'Good',
    'moodGreat': 'Great',
    'moodHowAreYou': 'How are you feeling?',
    'moodFactors': 'What affected your mood?',
    'moodFactorExercise': 'Exercise',
    'moodFactorCaffeine': 'Caffeine',
    'moodFactorStress': 'Stress',
    'moodFactorSocial': 'Social',
    'moodFactorNature': 'Nature',
    'moodFactorScreen': 'Screen Time',
    'moodFactorMeditation': 'Meditation',
    'moodFactorAlcohol': 'Alcohol',
    'moodNoteHint': 'Add a note about your day...',
    'moodSave': 'Save Mood',
    'moodLoggedToday': 'Mood logged for today!',
    'moodWeeklyTrend': 'Weekly Trend',
    'moodHistory': 'History',
    'moodNoEntries': 'No mood entries yet',
    'moodAverage': 'Average',
    'moodStreak': 'Streak',
    'moodTotalLogs': 'Total',

    // ── Challenges ─────────────────────────────────────────────────────
    'challenges': 'Challenges',
    'challengesTitle': 'Sleep Challenges',
    'challengeSleepDuration': 'Sleep 7+ Hours',
    'challengeSleepDurationDesc': 'Sleep at least 7 hours each night',
    'challengeConsistency': 'Consistent Schedule',
    'challengeConsistencyDesc': 'Go to bed at the same time',
    'challengeNoScreen': 'Screen-Free Night',
    'challengeNoScreenDesc': 'No screens 1 hour before bed',
    'challengeEarlyBed': 'Early Bird',
    'challengeEarlyBedDesc': 'Go to bed before 11 PM',
    'challengeMeditation': 'Zen Week',
    'challengeMeditationDesc': 'Meditate before sleep every day',
    'challengeNoSnooze': 'No Snooze Hero',
    'challengeNoSnoozeDesc': 'Wake up without hitting snooze',
    'challengeXpEarned': 'XP Earned',
    'challengeActive': 'Active Challenges',
    'challengeAvailable': 'Available Challenges',
    'challengeCompleted': 'Completed',
    'challengeDays': 'days',
    'challengeCheckIn': 'Check In',
    'challengeCheckedToday': 'Done today',
    'challengeStart': 'Start',
    'challengeEarned': 'earned',

    // ── Sleep Timer ────────────────────────────────────────────────────
    'sleepTimer': 'Timer',
    'sleepTimerTitle': 'Sleep Timer',
    'sleepTimerSelectDuration': 'Select Duration',
    'sleepTimerStart': 'Start Timer',
    'sleepTimerFinished': 'Time\'s up! Sweet dreams 🌙',
    'sleepTimerReset': 'Reset',
    'sleepTimerTip':
        'Set a timer for your sounds or stories to auto-stop while you drift off to sleep.',

    // ── Daily Tips ────────────────────────────────────────────────────
    'dailyTips': 'Tips',
    'dailyTipsTitle': 'Daily Sleep Tips',
    'dailyTipsTodayPick': 'Today\'s Picks',
    'dailyTipsSubtitle': 'Fresh tips every day for better sleep',
    'dailyTipsToday': 'Today\'s Tips',
    'dailyTipsAll': 'All Tips',
    'dt1Title': 'Consistent Schedule',
    'dt1Body':
        'Go to bed and wake up at the same time every day, even on weekends.',
    'dt2Title': 'Screen-Free Zone',
    'dt2Body': 'Put away screens at least 30 minutes before bedtime.',
    'dt3Title': 'Cool Room',
    'dt3Body': 'Keep your bedroom between 15-19°C for optimal sleep.',
    'dt4Title': 'Limit Caffeine',
    'dt4Body': 'Avoid caffeine at least 6 hours before bedtime.',
    'dt5Title': 'Daily Exercise',
    'dt5Body':
        'Regular exercise improves sleep, but avoid intense workouts near bedtime.',
    'dt6Title': 'Relaxation Routine',
    'dt6Body': 'Practice deep breathing or meditation before bed.',
    'dt7Title': 'Morning Sunlight',
    'dt7Body':
        'Get natural light exposure in the morning to regulate your circadian rhythm.',
    'dt8Title': 'Read Before Bed',
    'dt8Body':
        'Reading a physical book before bed can help you relax and fall asleep faster.',
    'dt9Title': 'Warm Bath',
    'dt9Body':
        'A warm bath 1-2 hours before bed can help lower your body temperature for sleep.',
    'dt10Title': 'Light Dinner',
    'dt10Body': 'Eat your last big meal at least 3 hours before bedtime.',
    'dt11Title': 'Calming Music',
    'dt11Body':
        'Listen to calming music or nature sounds to prepare for sleep.',
    'dt12Title': 'Comfortable Bed',
    'dt12Body':
        'Invest in a good mattress and pillows that support your sleeping position.',
    'dt13Title': 'Sleep Journal',
    'dt13Body':
        'Write down your thoughts and worries before bed to clear your mind.',
    'dt14Title': 'Plants in Bedroom',
    'dt14Body':
        'Plants like lavender and jasmine can improve air quality and promote relaxation.',
    'dt15Title': 'Cold Shower',
    'dt15Body':
        'A brief cold shower activates your parasympathetic nervous system for relaxation.',
    'dt16Title': '4-7-8 Breathing',
    'dt16Body':
        'Inhale for 4 seconds, hold for 7, exhale for 8. Repeat 3 times.',
    'dt17Title': 'Warm Milk',
    'dt17Body':
        'Warm milk contains tryptophan which can help promote sleepiness.',
    'dt18Title': 'Wear Socks',
    'dt18Body':
        'Warm feet help dilate blood vessels and signal the brain it\'s time to sleep.',
    'dt19Title': 'Set an Alarm',
    'dt19Body':
        'A consistent wake time is more important than a consistent bedtime.',
    'dt20Title': 'Aromatherapy',
    'dt20Body':
        'Lavender essential oil can promote relaxation and improve sleep quality.',
    'dt21Title': 'Gratitude Practice',
    'dt21Body':
        'List 3 things you\'re grateful for before bed to end the day positively.',
  };

  static const Map<String, String> _tr = {
    // ── General ───────────────────────────────────────────────────────
    'appName': 'SleepyApp',
    'error': 'Hata',
    'success': 'Başarılı',
    'loading': 'Yükleniyor...',
    'retry': 'Tekrar Dene',
    'back': 'Geri',
    'cancel': 'İptal',
    'ok': 'Tamam',
    'or': 'veya',
    'save': 'Kaydet',
    'submit': 'Gönder',
    'send': 'Gönder',
    'hours': 'saat',
    'quest': 'görev',
    'done': 'tamam',

    // ── Auth ──────────────────────────────────────────────────────────
    'welcomeBack': 'Hoş Geldin! 🌙',
    'welcomeBackSub': 'Sağlıklı uyku alışkanlıkları için giriş yap.',
    'emailLabel': 'E-posta',
    'emailRequired': 'E-posta gerekli',
    'emailInvalid': 'Geçerli bir e-posta girin',
    'passwordLabel': 'Şifre',
    'passwordRequired': 'Şifre gerekli',
    'passwordMin6': 'Şifre en az 6 karakter olmalı',
    'passwordMin8': 'Şifre en az 8 karakter olmalı',
    'passwordUppercase': 'En az bir büyük harf içermeli',
    'passwordDigit': 'En az bir rakam içermeli',
    'forgotPasswordQ': 'Şifremi Unuttum',
    'loginBtn': 'Giriş Yap',
    'noAccount': 'Hesabın yok mu? ',
    'signUpBtn': 'Kayıt Ol',
    'createAccount': 'Hesap Oluştur ✨',
    'startJourney': 'Uyku yolculuğuna bugün başla.',
    'fullNameLabel': 'Ad Soyad',
    'fullNameRequired': 'Ad soyad gerekli',
    'fullNameMin': 'En az 2 karakter girin',
    'confirmPasswordLabel': 'Şifre Tekrar',
    'passwordsMismatch': 'Şifreler eşleşmedi',
    'registerBtn': 'Kayıt Ol',
    'registerError': 'Kayıt Hatası',
    'haveAccount': 'Zaten hesabın var mı? ',
    'signInBtn': 'Giriş Yap',
    'resetPassword': 'Şifre Sıfırlama',
    'resetPasswordSub':
        'E-posta adresinize şifre sıfırlama linki göndereceğiz.',
    'emailSent': 'E-posta Gönderildi',
    'resetEmailSent': 'Şifre sıfırlama linki e-posta adresinize gönderildi.',
    'authUserNotFound': 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
    'authError': 'Kimlik doğrulama hatası: @code',

    // ── Nav / Tabs ────────────────────────────────────────────────────
    'home': 'Ana Sayfa',
    'sounds': 'Sesler',
    'learn': 'Öğren',
    'hero': 'Kahraman',
    'profile': 'Profil',

    // ── Dashboard ─────────────────────────────────────────────────────
    'goodNight': 'İyi Geceler',
    'goodMorning': 'Günaydın',
    'goodAfternoon': 'İyi Günler',
    'goodEvening': 'İyi Akşamlar',
    'sleepScore': 'Uyku Puanı',
    'sleepExcellent': 'Mükemmel',
    'sleepGood': 'İyi',
    'sleepFair': 'Orta',
    'sleepPoor': 'Yetersiz',
    'weeklyAvg': 'Haftalık Ort.',
    'sleepDebt': 'Uyku Borcu',
    'trackingActive': 'Uyku takibi aktif 😴',
    'sleepScoreIs': 'Uyku puanın: @score/100',
    'trackBtn': 'Takip Et',
    'quickAccess': 'Hızlı Erişim',
    'stories': 'Hikayeler',
    'meditation': 'Meditasyon',
    'badges': 'Rozetler',
    'assistant': 'Asistan',
    'games': 'Oyunlar',
    'myBadges': 'Rozetlerim',
    'seeAll': 'Tümünü Gör',
    'sleepTips': 'Uyku İpuçları',
    'more': 'Daha Fazla',
    'tipConsistentTitle': 'Tutarlı Uyku Saati',
    'tipConsistentBody':
        'Her gün aynı saatte yatmak ve kalkmak sirkadiyen ritminizi düzenler.',
    'tipScreenTitle': 'Ekrandan Uzak Dur',
    'tipScreenBody':
        'Yatmadan 1 saat önce telefon ve bilgisayar ekranlarından uzak durun.',
    'tipCoolRoomTitle': 'Serin Oda',
    'tipCoolRoomBody': 'İdeal uyku odası sıcaklığı 16-19 derece arasındadır.',

    // ── Sleep Tracking ────────────────────────────────────────────────
    'sleepTracking': 'Uyku Takibi',
    'sleepDataLoading': 'Uyku verisi yükleniyor...',
    'saved': 'Kaydedildi 🌙',
    'sleepRecordAdded': 'Uyku kaydın başarıyla eklendi.',
    'endSleep': 'Uykuyu Bitir',
    'startSleep': 'Uyumaya Başla',
    'addManualRecord': 'El ile uyku kaydı ekle',
    'recentRecords': 'Son Kayıtlar',
    'addSleepRecord': 'Uyku Kaydı Ekle',
    'bedtimeLabel': 'Yatış Saati',
    'wakeTimeLabel': 'Kalkış Saati',
    'sleepQuality': 'Uyku Kalitesi',
    'target': 'Hedef',
    'monthJan': 'Oca',
    'monthFeb': 'Şub',
    'monthMar': 'Mar',
    'monthApr': 'Nis',
    'monthMay': 'May',
    'monthJun': 'Haz',
    'monthJul': 'Tem',
    'monthAug': 'Ağu',
    'monthSep': 'Eyl',
    'monthOct': 'Eki',
    'monthNov': 'Kas',
    'monthDec': 'Ara',

    // ── Sounds ────────────────────────────────────────────────────────
    'soundsAndMusic': 'Sesler & Müzik 🎵',
    'soundLibrary': 'Ses Kütüphanesi',
    'aiMoodMusic': 'YZ Mod Müziği',
    'catAll': 'Tümü',
    'catNature': 'Doğa',
    'catRain': 'Yağmur',
    'catWhiteNoise': 'Gürültü',
    'catAmbient': 'Ortam',
    'catMedieval': 'Orta Çağ',
    'catLullaby': 'Ninni',
    'catInstrument': 'Enstrüman',
    'catMeditation': 'Meditasyon',
    'catBinaural': 'Binaural',
    'catHappy': 'Mutlu',
    'catPrayer': 'Dua',
    'catFavorites': 'Favoriler',
    'aiMoodTitle': 'YZ Mod Müziği',
    'aiMoodDesc': 'Şimdiki ruh halini veya bulunduğun ortamı anlat, '
        'YZ sana özel bir ses karışımı oluştursun.',
    'aiMoodHint': 'Örn: "Yağmurlu bir akşamda yorgun hissediyorum..."',
    'askAi': 'YZ\'ye Sor',
    'aiRecommendations': 'YZ Önerileri',
    'soundsLoadError': 'Sesler yüklenemedi: @e',

    // ── Sound names ───────────────────────────────────────────────────
    'soundHeavyRain': 'Yoğun Yağmur',
    'soundLightRain': 'Hafif Yağmur',
    'soundWaterDrop': 'Su Damlası',
    'soundOceanWaves': 'Okyanus Dalgaları',
    'soundForestBirds': 'Orman Kuşları',
    'soundWaterfall': 'Şelale',
    'soundThunder': 'Gök Gürültüsü',
    'soundWind': 'Rüzgar',
    'soundWhiteNoise': 'Beyaz Gürültü',
    'soundBrownNoise': 'Kahverengi Gürültü',
    'soundPinkNoise': 'Pembe Gürültü',
    'soundFan': 'Vantilatör',
    'soundCafeAmbiance': 'Kafe Ambiyansı',
    'soundFireplace': 'Şömine',
    'soundLibraryAmbiance': 'Kütüphane',
    'soundTrain': 'Tren',
    'soundMedievalTavern': 'Ortaçağ Tavernası',
    'soundMedievalLute': 'Ortaçağ Lütü',
    'soundMedievalForest': 'Ortaçağ Ormanı',
    'soundClassicLullaby': 'Klasik Ninni',
    'soundLullabyMelody': 'Ninni Melodisi',
    'soundSoftPiano': 'Yumuşak Piyano',
    'soundAcousticGuitar': 'Akustik Gitar',
    'soundTibetanBowl': 'Tibet Kasesi',
    'soundPeacefulFlute': 'Huzurlu Flüt',
    'soundOmMeditation': 'Om Meditasyon',
    'soundBinauralDelta': 'Binaural Delta (Derin uyku)',
    'soundBinauralTheta': 'Binaural Theta (Rüya)',
    'soundJoyBirds': 'Neşe Kuşları',
    'soundWindChime': 'Rüzgar Çanı',
    'soundCatPurr': 'Kedi Mırıltısı',
    'soundPrayerAmbiance': 'Namaz Ambiyansı',

    // ── Learning ──────────────────────────────────────────────────────
    'sleepGuide': 'Uyku Rehberi 📖',
    'searchArticles': 'Makale ara...',
    'noArticles': 'Makale bulunamadı.',
    'min': 'dk',
    'catBiology': 'Biyoloji',
    'catTechnology': 'Teknoloji',
    'catNutrition': 'Beslenme',
    'catEnvironment': 'Ortam',
    'catTechnique': 'Teknik',
    'catSports': 'Spor',
    'catPsychology': 'Psikoloji',
    'catHygiene': 'Hijyen',
    'articleCircadian': 'Sirkadiyen Ritim Nedir?',
    'articleCircadianBody':
        'Uyku-uyanıklık döngünüzü yöneten iç saatiniz hakkında her şey.',
    'articleScreen': 'Ekran Mağarası Sendromu',
    'articleScreenBody':
        'Mavi ışık uykuyu nasıl etkiler ve nasıl korunabilirsiniz.',
    'articleDeepSleep': 'Derin Uyku Evreleri',
    'articleDeepSleepBody': 'REM ve NREM uyku evrelerinde beyin ne yapar?',
    'articleCaffeine': 'Kafein ve Uyku',
    'articleCaffeineBody': 'Kafein ne zaman kesilebilir? Yarı ömür nedir?',
    'articleCoolRoom': 'Serin Ortamda Daha İyi Uyu',
    'articleCoolRoomBody':
        'İdeal uyku odası sıcaklığını nasıl ayarlayabilirsiniz.',
    'articleBreathing': '4-7-8 Nefes Tekniği',
    'articleBreathingBody':
        'Birkaç dakikada uyumanızı sağlayan güçlü bir teknik.',
    'articleExercise': 'Spor ve Uyku Kalitesi',
    'articleExerciseBody':
        'Hangi antrenman türü uyku kalitesini en çok artırır?',
    'articleStress': 'Stres Uyku Düşmanı',
    'articleStressBody':
        'Kortizol seviyesi uyku üzerinde nasıl olumsuz etki yapar?',
    'articleMelatonin': 'Melatonin Takviyesi',
    'articleMelatoninBody':
        'Melatonin ne zaman ve nasıl kullanılır? Doğal üretimi artırmanın yolları.',
    'articleHygiene': 'Uyku Hijyeni 101',
    'articleHygieneBody': 'Sağlıklı uyku alışkanlıklarının temel kuralları.',
    'articlePowerNap': 'Power Nap Bilimi',
    'articlePowerNapBody': '20 dakikalık bir uyku neden bu kadar etkilidir?',
    'articleChronotype': 'Kişisel Uyku Profili',
    'articleChronotypeBody':
        'Sabah insanı mı gece kuşu musunuz? Kronotiğinizi keşfedin.',

    // ── Rewards ───────────────────────────────────────────────────────
    'myBadgesTitle': 'Rozetlerim',
    'noBadgesYet':
        'Henüz rozet kazanılmadı.\nDüzenli uyuyarak rozetleri kilitle!',
    'locked': 'Kilitli',
    'lockedCount': 'Kilitli (@count)',
    'yourSleepScore': 'Uyku Puanın',
    'earned': '✓ Kazanıldı',
    'earnedCount': 'Kazanılanlar (@count)',
    'scoreLabel': 'Skor: @score+',

    // ── Feedback ──────────────────────────────────────────────────────
    'feedback': 'Geri Bildirim',
    'howWasApp': 'SleepyApp\'i nasıl buldunuz?',
    'feedbackHelper': 'Görüşleriniz uygulamayı geliştirmemize yardımcı olur.',
    'yourRating': 'Puanınız',
    'feedbackPlaceholder': 'Düşüncelerinizi paylaşın... (isteğe bağlı)',
    'submitting': 'Gönderiliyor...',
    'thankYou': 'Teşekkürler! 🙏',
    'feedbackSent': 'Geri bildiriminiz başarıyla iletildi.',
    'anErrorOccurred': 'Bir hata oluştu.',
    'ratingVeryBad': 'Çok Kötü 😞',
    'ratingBad': 'Kötü 😕',
    'ratingAverage': 'Orta 😐',
    'ratingGood': 'İyi 😊',
    'ratingExcellent': 'Mükemmel! 🤩',

    // ── Settings ──────────────────────────────────────────────────────
    'settings': 'Ayarlar',
    'themeSection': 'GÖRÜNÜM',
    'darkMode': 'Karanlık Mod',
    'lightMode': 'Aydınlık Mod',
    'languageSection': 'Dil / Language',
    'turkish': 'Türkçe',
    'english': 'English',
    'notifications': 'Bildirimler',
    'sleepReminder': 'Uyku Hatırlatıcı',
    'sleepReminderSub': 'Yatma saatinde bildirim al',
    'sleepSchedule': 'Uyku Programı',
    'bedtime': 'Yatma Saati',
    'sleepGoal': 'Uyku Hedefi',
    'account': 'Hesap',
    'privacyPolicy': 'Gizlilik Politikası',
    'termsOfService': 'Kullanım Koşulları',
    'logout': 'Çıkış Yap',
    'logoutConfirm': 'Hesabından çıkmak istediğine emin misin?',

    // ── PRO ───────────────────────────────────────────────────────────
    'proWelcome': '🎉 PRO\'ya hoş geldin! Tüm özellikler kilidini açtı.',
    'purchaseFailed': 'Satın alma başarısız oldu.',
    'proPremiumExp': 'Daha iyi uyku için premium deneyim',
    'proWhatYouGet': 'PRO ile neler kazanırsın?',
    'monthlyPlan': 'Aylık Plan',
    'monthlyLabel': 'aylık',
    'yearlyPlan': 'Yıllık Plan',
    'yearlyLabel': 'yıllık (%33 indirim)',
    'bestValue': 'EN AVANTAJLI',
    'restorePurchases': 'Satın Alımları Geri Yükle',
    'subscriptionNote':
        'Abonelik otomatik yenilenir. İstediğiniz zaman iptal edebilirsiniz.',
    'proSleepyAssistant': 'Sleepy Assistant',
    'proAssistantDesc': 'YZ destekli kişisel uyku danışmanı',
    'proUnlimitedSounds': 'Sınırsız Ses & Karıştırıcı',
    'proUnlimitedSoundsDesc': '6\'ya kadar eş zamanlı ses katmanı',
    'proAiMoodMusic': 'YZ Mod Müziği',
    'proAiMoodMusicDesc': 'Ruh haline göre kişiselleştirilmiş müzik',
    'proAllContent': 'Tüm İçerikler',
    'proAllContentDesc': 'Tüm uyku rehberi makaleleri',
    'proSmartAlarm': 'Akıllı Alarm',
    'proSmartAlarmDesc': 'Uyku döngüsüne göre uyanış alarmı',
    'proAdvancedAnalysis': 'Gelişmiş Analiz',
    'proAdvancedAnalysisDesc': 'Detaylı uyku grafikleri ve raporlar',
    'proSpecialBadges': 'Özel Rozetler',
    'proSpecialBadgesDesc': 'PRO üyelere özel ödüller',
    'proCloudSync': 'Bulut Senkronizasyon',
    'proCloudSyncDesc': 'Cihazlar arası uyku verisi senkronizasyonu',
    'goPro': '✨ PRO\'ya Geç',

    // ── Sleepy Assistant ──────────────────────────────────────────────
    'aiSleepConsultant': 'YZ destekli uyku danışmanı',
    'assistantGreeting':
        'Merhaba! Ben Sleepy Assistant 🌙\n\nUyku sorunlarınız, uyku rutinleri veya daha iyi dinlenme için ipuçları hakkındaki sorularınızı yanıtlamaya hazırım.\n\nNasıl yardımcı olabilirim?',
    'proGateDesc':
        'YZ destekli kişisel uyku danışmanınıza erişmek için PRO üye olun.',
    'proGateFeature1': 'Uyku sorunlarınız için kişisel tavsiyeler',
    'proGateFeature2': 'Meditasyon ve nefes teknikleri rehberliği',
    'proGateFeature3': 'Uyku rutini oluşturma desteği',
    'askAboutSleep': 'Uyku hakkında bir şey sorun…',

    // ── Daily Limit & Pro Sound Dialogs ───────────────────────────────
    'dailyLimitTitle': 'Günlük Limit Doldu',
    'dailyLimitDesc':
        'Ücretsiz kullanıcılar günde 1 kez YZ asistanı kullanabilir. Sınırsız erişim için PRO\'ya geçin! 🌙',
    'dailyLimitBanner':
        'Günlük ücretsiz mesaj hakkınız doldu. Sınırsız erişim için yükseltin.',
    'proSoundTitle': 'PRO Ses',
    'proSoundDesc':
        'Bu ses PRO üyelere özeldir. Tüm premium seslerin kilidini açmak için yükseltin! 🎵',

    // ── Level System ──────────────────────────────────────────────────
    'levelTitle1': 'Uyuyan Tohum',
    'levelTitle2': 'Rüya Tomurcuğu',
    'levelTitle3': 'Yıldız Yolcusu',
    'levelTitle4': 'Ay Bekçisi',
    'levelTitle5': 'Rüya Dokuyucu',
    'levelTitle6': 'Gece Kaşifi',
    'levelTitle7': 'Uyku Üstadı',
    'levelTitle8': 'Rüya Mimarı',
    'levelTitle9': 'Gece Efendisi',
    'levelTitle10': 'Uyku Tanrısı',
    'levelTitle11': 'Ebedi Rüya',
    'levelSub': 'Seviye @level  •  Uyku Kahramanı',
    'dayStreak': '@days günlük dizi!',
    'newTitleEarned': '✨  Yeni Unvan Kazanıldı',
    'proContinue': 'PRO ile devam et',
    'proReachLv99': '✨ PRO ile Lv.99\'a Ulaş!',
    'nextLv': 'Sonraki: Lv.@level',
    'lv6ProRequired': 'Lv.6 için PRO gerekli',
    'maxLevelReached': 'Maksimum Seviyeye Ulaştınız!',
    'dailyQuestsTitle': '📅  Günlük Görevler',
    'levelPath': '🗺️  Seviye Yolu',
    'myHero': '📊  Kahramanım',
    'totalXpLabel': 'Toplam XP',
    'streakLabel': 'Dizi',
    'activeDaysLabel': 'Aktif Gün',
    'levelUpTitle': 'SEVİYE ATLADINIZ!',
    'levelUpSub': 'Seviye @old  →  Seviye @new',
    'levelUpContinue': 'Harika!  Devam Et  ✨',
    'proButtonSmall': 'PRO OL',
    'streakDays': '@days Gün',

    // ── Daily Quests ──────────────────────────────────────────────────
    'questDailyLogin': 'Günlük Giriş',
    'questDailyLoginDesc': 'Her gün uygulamayı aç',
    'questSleepTracking': 'Uyku Takibi',
    'questSleepTrackingDesc': 'Bu gece uyku takibini başlat',
    'questSleepSound': 'Uyku Sesi',
    'questSleepSoundDesc': '10 dakika uyku sesi dinle',
    'questMiniGame': 'Mini Oyun',
    'questMiniGameDesc': 'Bir uyku oyununu oyna',
    'questSleepSchool': 'Uyku Okulu',
    'questSleepSchoolDesc': 'Uyku bilgisi bölümünü ziyaret et',

    // ── Games Hub ─────────────────────────────────────────────────────
    'sleepFilms': '🎬 Uyku Filmleri',
    'spaceGamesAndFilms': 'Uzay Oyunlar & Filmler',
    'playWatchExplore': 'Rahatlamak için oyna, izle, keşfet',
    'totalGameScore': 'Toplam Oyun Puanı',
    'watchedFilms': 'İzlenen Film',
    'gamesTab': '🎮 Oyunlar',
    'filmsTab': '🎬 Uyku Filmleri',
    'gameBadgesTab': '🏆 Oyun Rozetleri',
    'cosmicBreath': 'Kozmik Nefes',
    'cosmicBreathDesc': '4-4-6-2 nefes tekniği • Stres azaltır',
    'starCatcher': 'Yıldız Avcısı',
    'starCatcherDesc': 'Düşen yıldızları yakala • 90 saniye',
    'balloonGarden': 'Balon Bahçesi',
    'balloonGardenDesc': '3 dakika • Yavaş yavaş patlat • Stressiz',
    'sheepCounting': 'Koyun Sayma',
    'sheepCountingDesc': 'Klasik uyku ritüeli • Oldukça sakin',
    'sleepFilmsTitle': 'Uyku Filmleri',
    'filmsAnimDesc': '8 animasyon • Uzay, okyanus, aurora ve daha fazlası',
    'gameBadgesPlay': 'Oyun oynayarak ve film izleyerek rozet kazan!',
    'playBtn': 'Oyna →',

    // ── Breathing Game ────────────────────────────────────────────────
    'phaseInhale': 'Nefes Al',
    'phaseHold': 'Tut',
    'phaseExhale': 'Nefes Ver',
    'phaseRest': 'Bekle',
    'cyclesProgress': 'Döngü @current / @total',
    'cosmicBreathIntro':
        '4-4-6-2 nefes tekniğiyle evrenle uyum sağla.\n10 döngüde 500 puan kazan.',
    'startCosmicBreath': '🌌  Başla',
    'awesome': 'Harika!',
    'cyclesCompleted': '@cycles döngü tamamladın',
    'points': 'PUAN',
    'cosmicBreathBadge': '"Kozmik Nefes" rozeti kazanıldı!',
    'playAgain': 'Tekrar Oyna',
    'backToGames': 'Oyunlar\'a Dön',

    // ── Sheep Counter ─────────────────────────────────────────────────
    'sheepTitle': 'Koyun Sayma',
    'sleepTime': 'Uyku vakti… 💤',
    'countedSheepFooter': 'koyun sayıldı 🐑',
    'sheepMoreForBadge': 'Rozet için @count koyun daha say →  🏅',
    'badgeEnough': 'Rozet için yeterli! 🎉',
    'sheepCounted': 'Sayılan Koyun',
    'score': 'Puan',
    'badgeThreshold': 'Rozet Eşiği',
    'thirtySheep': '30 koyun',
    'badgeEarned': 'Rozet Kazanıldı!',
    'sleepySheep': 'Uykulu Koyun',
    'again': 'Tekrar',

    // ── Bubble Pop ────────────────────────────────────────────────────
    'balloonCountLabel': 'BALON',
    'goalLabel': 'HEDEF',
    'secondsLeft': '@sec sn',
    'tapBubbles': 'Baloncuklara dokun ve patlat 🫧',
    'balloonGardenTitle': 'Balon Bahçesi',
    'sessionOver': 'Oturum Bitti!',
    'poppedBalloons': 'Patlayan Balon',
    'fiftyBalloons': '50 balon',
    'balloonPopper': 'Balon Patlatıcı',

    // ── Star Catcher ──────────────────────────────────────────────────
    'starCatcherTitle': 'Yıldız Avcısı',
    'gameOver': 'Oyun Bitti!',
    'caughtLabel': 'YAKALANDI',
    'tapStars': 'Yıldızlara dokun ve yakala!',
    'caughtStars': 'Yakalanan Yıldız',
    'targetScore': 'Hedef puan',
    'threeHundredPoints': '300 puan',
    'starCatcherBadge': 'Yıldız Avcısı',

    // ── Sleep Films ───────────────────────────────────────────────────
    'filmCompleted': 'Film tamamlandı ✨',
    'swipeForNext': 'Sonraki sahne için sağa kaydır →',
    'sceneLabel': 'Sahne @current/@total',
    'minutesShort': '~3 dk',
    'dreamWeaver': 'Rüya Dokuyucu',
    'filmList': 'Film Listesi',
    'sleepFilmsAppbar': 'Uyku Filmleri',
    'filmsCount': '@count adet huzur verici animasyon • 2-3 dakika',

    // ── Sleep Chart ───────────────────────────────────────────────────
    'chartMon': 'Pzt',
    'chartTue': 'Sal',
    'chartWed': 'Çar',
    'chartThu': 'Per',
    'chartFri': 'Cum',
    'chartSat': 'Cmt',
    'chartSun': 'Paz',
    'hoursShort': 'sa',
    'targetHoursLabel': 'Hedef @hours sa',

    // Film titles & subtitles
    'filmStarJourney': 'Yıldız Yolculuğu',
    'filmStarJourneySub': 'Galaksi süvarisi ol',
    'filmNebula': 'Nebula Bahçesi',
    'filmNebulaSub': 'Renklerin dans ettiği yer',
    'filmMoon': 'Ay\'a Doğru',
    'filmMoonSub': 'Ay ışığında süzül',
    'filmAurora': 'Aurora',
    'filmAuroraSub': 'Kuzey ışıklarında kaybol',
    'filmOcean': 'Okyanus Derinlikleri',
    'filmOceanSub': 'Biyolüminesan dünya',
    'filmClouds': 'Bulut Sörfü',
    'filmCloudsSub': 'Pembe bulutlarda süzül',
    'filmCrystal': 'Kristal Orman',
    'filmCrystalSub': 'Işık ve kristallerin dansı',
    'filmVoid': 'Sonsuz Uzay',
    'filmVoidSub': 'Derin meditasyon yolculuğu',

    // Film narrations
    'filmStar1':
        'Karanlık uzayın derinliklerinde süzülüyorsun. Yüzlerce yıldız seninle dans ediyor.',
    'filmStar2':
        'Nebulalar arasından geçerken renk renk ışıklar seni sarıyor. Her nefeste daha da hafifleşiyorsun.',
    'filmStar3':
        'Uzak galaksilerin ışıltısı seni huzura davet ediyor. Zihnin dinginleşiyor, beden gevşiyor.',
    'filmStar4':
        'Evrenin sonsuzluğunda küçük ama değerli bir parçasısın. Bu anın keyfini çıkar.',
    'filmNebula1':
        'Kırmızı, mor ve turuncu bulutlar yavaşça birbirine karışıyor. Doğanın resim sanatı.',
    'filmNebula2':
        'Gaz bulutları arasında yeni yıldızlar doğuyor. Sen de her nefeste yeniden doğuyorsun.',
    'filmNebula3':
        'Renk dalgaları beynini yavaşlatıyor. Beden ağırlaşıyor, gözler kapanmak istiyor.',
    'filmNebula4':
        'Tüm renkler tek bir beyaz ışıkta birleşiyor. Huzur bu ışık gibi seni sarıyor.',
    'filmMoon1':
        'Hilal ay yavaşça büyüyor. Ay\'ın soğuk ışığı yüzüne vuruyor, kalbin sakinleşiyor.',
    'filmMoon2':
        'Ay yüzeyindeki kraterleri fark ediyorsun. Her krater bir anı, her iz bir hikaye.',
    'filmMoon3':
        'Ay\'ın çekimiyle sürükleniyorsun. Ağırlık yok, sadece yavaş bir dans.',
    'filmMoon4':
        'Dünya uzaktan küçük bir mavi nokta. Bu sessizlikte sadece nefes var.',
    'filmAurora1':
        'Yeşil ve mavi kuşaklar gökyüzünde dans ediyor. Kuzey ışıkları sana bir şeyler fısıldıyor.',
    'filmAurora2':
        'Işık dalgaları ritmik olarak titreşiyor. Bu ritim nefes ritmini yumuşatıyor.',
    'filmAurora3':
        'Mor ve pembe tonlar yeşile katılıyor. Gökyüzü canlı bir tablo gibi.',
    'filmAurora4':
        'Işıklar yavaşça soluklaşıyor. Gece seni kucaklıyor, uyku kapıyı çalıyor.',
    'filmOcean1':
        'Derinlere indikçe mavi daha da koyulaşıyor. Denizanası gibi süzülüyorsun.',
    'filmOcean2':
        'Biyolüminesan balıklar etrafında dans ediyor. Karanlıkta bile ışık bulunuyor.',
    'filmOcean3':
        'Okyanus akıntısı seni taşıyor. Kontrolü bırakmak bu kadar güzel olabilir.',
    'filmOcean4':
        'Derinlerin sessizliği beyne işliyor. Dalgaların ritmi uyku ritmine dönüşüyor.',
    'filmCloud1':
        'Pembe ve turuncu bulutların üzerinde yürüyorsun. Pamuk gibi yumuşak, hafif bir his.',
    'filmCloud2':
        'Bulutlar arasından güneş ışınları süzülüyor. Her ışın sıcaklık ve huzur getiriyor.',
    'filmCloud3':
        'Rüzgar seni nazikçe ileri taşıyor. Bulutlar üzerinde süzülmek uyku gibi hissettiriyor.',
    'filmCloud4':
        'Gün batımı renkleri soluklaşıyor. Gece yavaşça örtüyor, uyku buyur ediyor.',
    'filmCrystal1':
        'Dev kristaller mağaranın duvarlarından fışkırıyor. Her biri bin renk kırıyor.',
    'filmCrystal2':
        'Işık kristallerin içinde dans ediyor. Gökkuşağı renkleri tavanı süslüyor.',
    'filmCrystal3':
        'Kristallere dokunduğunda tatlı bir titreşim hissediyorsun. Beyin bu frekansla sakinleşiyor.',
    'filmCrystal4':
        'Tüm kristaller aynı anda parlıyor, sonra sönüyor. Bu ritim nefes ritminin ta kendisi.',
    'filmVoid1':
        'Tamamen karanlık. Sadece nefes var. Bu karanlık korkutucu değil, rahatlatıcı.',
    'filmVoid2':
        'Uzakta küçük bir ışık var. Ona doğru yavaşça ilerliyorsun. Acelesi yok.',
    'filmVoid3':
        'Işık büyüyor, bir yıldıza dönüşüyor. Sıcaklığını hissediyorsun, zihin dinginleşiyor.',
    'filmVoid4':
        'Her şey tamam. Güvendesin. Dinlenmek için doğru yerdesin. Uyku artık çok yakın.',

    // ── Badge Names ───────────────────────────────────────────────────
    'badgeCosmicBreath': 'Kozmik Nefes',
    'badgeStarCatcher': 'Yıldız Avcısı',
    'badgeDreamWeaver': 'Hayal Dokuyucu',
    'badgeGalaxyTraveler': 'Galaksi Gezgini',
    'badgeSleepWise': 'Uyku Bilgesi',
    'badgeBalloonPopper': 'Balon Patlatıcı',
    'badgeSleepySheep': 'Uykulu Koyun',

    // ── Earned Badge Display ──────────────────────────────────────────
    'earnedBadge': 'Kazanıldı ✓',

    // ── Chart ─────────────────────────────────────────────────────────
    'dayMon': 'Pzt',
    'dayTue': 'Sal',
    'dayWed': 'Çar',
    'dayThu': 'Per',
    'dayFri': 'Cum',
    'daySat': 'Cmt',
    'daySun': 'Paz',

    // ── Error messages ────────────────────────────────────────────────
    'errNoInternet': 'İnternet bağlantısı yok.',
    'errCacheRead': 'Yerel veri okuma hatası.',
    'errSessionExpired': 'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.',
    'errUnexpected': 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.',
    'errTimeout': 'Bağlantı zaman aşımı. Tekrar deneyin.',
    'errCertificate': 'Güvenli bağlantı kurulamadı.',
    'errCancelled': 'İstek iptal edildi.',
    'errInvalidRequest': 'Geçersiz istek.',
    'errNoAccess': 'Bu kaynağa erişim izniniz yok.',
    'errNotFound': 'Kaynak bulunamadı.',
    'errValidation': 'Veri doğrulama hatası.',
    'errTooMany': 'Çok fazla istek. Lütfen bekleyin.',
    'errServer': 'Sunucu hatası (@code).',
    'errSleepHistoryLoad': 'Uyku geçmişi yüklenemedi: @e',
    'errRecordSave': 'Kayıt kaydedilemedi: @e',
    'errRecordDelete': 'Kayıt silinemedi: @e',

    // ── New Games ─────────────────────────────────────────────────────
    'game_dream_labyrinth': 'Rüya Labirenti',
    'game_dream_labyrinth_desc':
        'Rüya labirentinde gezin ve ay parçalarını toplayın.',
    'game_moon_runner': 'Ay Koşucusu',
    'game_moon_runner_desc':
        'Ay yüzeyinde koş, kraterlerden kaç, yıldız topla.',
    'game_nebula_match': 'Nebula Eşleştir',
    'game_nebula_match_desc': 'Kozmik kartları çevir ve eşleşen çiftleri bul.',
    'game_galaxy_puzzle': 'Galaksi Bulmacası',
    'game_galaxy_puzzle_desc':
        'Kozmik görüntüyü geri yüklemek için karoları kaydır.',
    'game_cosmic_flow': 'Kozmik Akış',
    'game_cosmic_flow_desc':
        'Kozmos seni uykuya sürüklerken enerji düğümlerine doğru ritimde dokun.',
    'moons': 'Aylar',
    'moves': 'Hamle',
    'time': 'Süre',
    'game_won': 'Kazandın! 🎉',
    'streak': 'Seri',
    'level': 'Seviye',
    'bpm': 'BPM',
    'best': 'En İyi',
    'start': 'Başla',
    'lanes': 'Şerit',
    'game_over': 'Oyun Bitti',
    'play_again': 'Tekrar Oyna',
    'pairs_found': 'Bulunan Çift',
    'puzzle_complete': 'Bulmaca Tamamlandı!',

    // ── Zodiac & Astral ───────────────────────────────────────────────
    'zodiac_hub': 'Burçlar & Astral',
    'zodiac_hub_desc': 'Burcunu keşfet ve astral egzersizleri dene.',
    'daily_horoscope': 'Günlük Burç Yorumu',
    'compatibility': 'Uyum',
    'astral_exercises': 'Astral Egzersizler',
    'zodiac_detail': 'Burç Detayı',
    'zodiac_compatibility': 'Burç Uyumu',
    'your_sign': 'Burcun',
    'select_sign': 'Burç Seç',
    'partner_sign': 'Partner Burcu',
    'love': 'Aşk',
    'friendship': 'Dostluk',
    'sleep_harmony': 'Uyku Uyumu',
    'astral_connection': 'Astral Bağlantı',
    'overall': 'Genel',
    'all_compatibilities': 'Tüm Uyumlar',
    'set_birthday': 'Doğum Günü Belirle',
    'element': 'Element',
    'modality': 'Modalite',
    'sleep_profile': 'Uyku Profili',
    'astral_advice': 'Astral Tavsiye',
    'sign_traits': 'Özellikler',
    'exercise_steps': 'Adımlar',
    'begin_exercise': 'Egzersize Başla',
    'breathe_in': 'Nefes Al',
    'breathe_out': 'Nefes Ver',
    'hold': 'Tut',
    'step_n': 'Adım @n',
    'duration_min': '@n dk',
    'difficulty': 'Zorluk',
    'category': 'Kategori',
    'beginner': 'Başlangıç',
    'intermediate': 'Orta',
    'advanced': 'İleri',

    // ── Zodiac Signs ──────────────────────────────────────────────────
    'zodiac_aries': 'Koç',
    'zodiac_taurus': 'Boğa',
    'zodiac_gemini': 'İkizler',
    'zodiac_cancer': 'Yengeç',
    'zodiac_leo': 'Aslan',
    'zodiac_virgo': 'Başak',
    'zodiac_libra': 'Terazi',
    'zodiac_scorpio': 'Akrep',
    'zodiac_sagittarius': 'Yay',
    'zodiac_capricorn': 'Oğlak',
    'zodiac_aquarius': 'Kova',
    'zodiac_pisces': 'Balık',

    // ── Astral Exercise Titles ────────────────────────────────────────
    'astral_projection': 'Astral Projeksiyon',
    'lucid_dreaming': 'Lusid Rüya',
    'chakra_alignment': 'Çakra Hizalama',
    'cosmic_energy_meditation': 'Kozmik Enerji Meditasyonu',
    'third_eye_activation': 'Üçüncü Göz Aktivasyonu',

    // ── Sleep Stories ─────────────────────────────────────────────────
    'sleepStories': 'Uyku Masalları',
    'storiesSubtitle': 'Uykuya yolculuk eden büyülü masallar',
    'scenes': 'sahne',
    'storyRedTitle': 'Kırmızı Başlıklı Kız',
    'storyRedSub': 'Ay ışığında büyülü bir orman yürüyüşü',
    'storyRed01':
        'Bir varmış bir yokmuş, küçük kırmızı başlıklı kız, ay ağaçların üzerinde yükselirken ormana doğru yola çıktı...',
    'storyRed02':
        'Gaz lambasının sıcak altın ışığı patikayı aydınlattı. Ağaçlar, ormanın derinliklerine ilerlerken kadim ninniler fısıldadı...',
    'storyRed03':
        'Eğrelti otlarının arasında dans eden ateşböceklerini izlemek için bir an durdu. Minicik ışıkları düşmüş yıldızlar gibi yanıp söndü...',
    'storyRed04':
        'Yumuşak orman zemini adımlarını yastıkladı. Bir baykuş yüksek bir daldan nazikçe öttü ve onu geceye karşıladı...',
    'storyRed05':
        'Mantarların soluk mavi bir ışıkla parıldadığı bir açıklığa geldi. Ay tepesinde gümüş bir sikke gibi parlıyordu...',
    'storyRed06':
        'Hafif bir esinti çam ve kır çiçeklerinin kokusunu taşıdı. Huzurun onu sıcak bir battaniye gibi sardığını hissetti...',
    'storyRed07':
        'Orman artık sessizleşiyordu, sanki doğanın kendisi uykuya dalıyordu. Rüzgâr bile daha yumuşak fısıldamaya başladı...',
    'storyRed08':
        'En yaşlı ağacın altında rahat bir köşe buldu, oturdu ve lambasını kıstı. Yıldızlar gözleri yavaşça kapanırken sessiz bir ninni söyledi...',

    'storyMoonTitle': 'Ay Prensesi',
    'storyMoonSub': 'Gümüş çayırlarda göksel bir yolculuk',
    'storyMoon01':
        'Bulutların çok üstünde, ay ışığından yapılmış bir prenses gümüş yıldız tozu köprüsüne adım attı...',
    'storyMoon02':
        'Lambası elindeki minicik ve parlak ayın kendisiydi. Her adımı yolda yumuşak beyaz bir iz bıraktı...',
    'storyMoon03':
        'Her yaprağı nazik mor bir tonla parlayan sonsuz yıldız çiçeği çayırına baktı...',
    'storyMoon04':
        'Gece esintisi sadece onun duyabileceği bir melodi söyledi, takımyıldızlar arasında ipek bir kurdele gibi süzüldü...',
    'storyMoon05':
        'Göksel bir gölün kenarında durdu, yüzeyi bin uyuyan galaksiyi yansıtıyordu...',
    'storyMoon06':
        'Prenses ay ışığından bir bulutun üzerine uzandı ve evren onu nazikçe uykuya salladı...',

    'storyStarTitle': 'Yıldız Toplayıcı',
    'storyStarSub': 'Sessiz gecede düşen yıldızları topluyoruz',
    'storyStar01':
        'Her gece, genç bir hayalperest bir fenerle tepelerin üstünde yürür, gökyüzünden düşen yıldızları arar...',
    'storyStar02':
        'Bu gece gökyüzü cömertti. Altın bir yıldız çimenler arasında yatıyordu, hâlâ sıcak ve hafifçe uğulduyordu...',
    'storyStar03':
        'Hayalperest onu nazikçe aldı ve ışıkla atmasını izledi. Her yıldız içinde uyuyan bir dilek taşıyordu...',
    'storyStar04':
        'Sırt boyunca daha ilerlerken, daha fazla yıldız çayırı karanlıkta parlayan çiy taneleri gibi süsledi...',
    'storyStar05':
        'Cepleri yıldız ışığıyla dolu hayalperest tepeye oturdu ve Samanyolu\'nun yavaşça nefes alışını izledi...',
    'storyStar06':
        'Toplanan yıldızlar teker teker süzülüp evlerine döndü. Hayalperest gülümsedi ve altın bir uykuya daldı...',

    'storyGnomeTitle': 'Orman Cücesi',
    'storyGnomeSub': 'Küçük bir koruyucunun gece devriyesi',
    'storyGnome01':
        'Büyülü ormanın derinliklerinde, mantar şapkalı küçük bir cüce kadim ağaçların arasında gece yürüyüşüne başladı...',
    'storyGnome02':
        'Yeşil feneri uğuldarken uyuyan çiçekleri kontrol etti ve minik orman yaratıklarının etrafına yosun battaniyeleri sardı...',
    'storyGnome03':
        'Şırıl şırıl akan bir derenin yanında durdu, suyu dağlar kadar eski bir şarkı söylüyordu...',
    'storyGnome04':
        'Ateşböcekleri eski dostlar gibi etrafında toplandı, parıltıları ormanı yaşayan bir masala dönüştürdü...',
    'storyGnome05':
        'Cüce bir mantarın üzerine oturdu ve minicik flütünü çaldı. Melodi ağaçların arasında sıcak bal gibi süzüldü...',
    'storyGnome06':
        'Orman tamamen sessizleştiğinde, cüce kovuk bir kütüğün içine kıvrılıp feneri yumuşak bir köze döndürdü...',

    'storyOceanTitle': 'Okyanus Rüyası',
    'storyOceanSub': 'Biyolüminesan sularda süzülüyoruz',
    'storyOcean01':
        'Dalgaların altında, güneş ışığının asla ulaşamadığı yerde, nazik bir yüzücü canlı ışık dünyasında süzülüyordu...',
    'storyOcean02':
        'Denizanaları parlayan fenerler gibi süzüldü, derinliklerde yumuşak camgöbeği ve menekşe kurdeleler bıraktı...',
    'storyOcean03':
        'Yüzücü dev bir deniz kaplumbağasının mercan katedralinden sessizce süzülmesini izlemek için durdu...',
    'storyOcean04':
        'Minik balıklar spiraller halinde döndü, pulları saçılmış elmaslar gibi biyolüminesan parıltıyı yakaladı...',
    'storyOcean05':
        'Uzakta bir balina şarkı söyledi, derin sesi kozmik bir ninni gibi suyun içinde titreşti...',
    'storyOcean06':
        'Yüzücü yumuşak deniz çimenlerinden bir yatağa süzüldü, okyanusun nazik sallanmasına sarılıp uykuya daldı...',

    // ── No Ads / Subscription ────────────────────────────────────────
    'noAdsTitle': 'Reklamsız',
    'noAdsSubtitle': 'Kesintisiz uyku deneyiminin keyfini çıkar',
    'noAdsMonthlyPlan': 'Reklamsız Plan',
    'noAdsMonthlyLabel': 'Tüm reklamları kaldır — aylık abonelik',
    'noAdsActivated': '🎉 Reklamlar kaldırıldı! Temiz deneyimin keyfini çıkar.',
    'noAdsBenefit1': 'Reklamsız Deneyim',
    'noAdsBenefit1Desc': 'Uygulama genelinde tamamen reklamsız',
    'noAdsBenefit2': 'Hızlı Deneyim',
    'noAdsBenefit2Desc': 'Reklam bekleme yok, her şeye anında erişim',
    'noAdsBenefit3': 'Huzurlu Uyku',
    'noAdsBenefit3Desc': 'Dikkat dağıtıcılar olmadan uykuna odaklan',
    'noAdsUpgradePro': 'Bunun yerine PRO\'ya yüksel',
    'noAdsUpgradeProDesc': 'Tüm PRO özellikler + Reklamsız dahil',
    'noAdsProActive': 'PRO Üye — Reklamsız Aktif',
    'noAdsProActiveDesc': 'PRO üyeliğinize dahil reklamsız deneyim',
    'noAdsSubscriptionNote':
        '₺49,99/ay. Abonelik otomatik yenilenir. İstediğiniz zaman iptal edebilirsiniz.',
    'noAdsActiveDesc': 'Reklamsız deneyim aktif',
    'noAdsInactiveDesc': '₺49,99/ay — Tüm reklamları kaldır',
    'adPlaceholder': 'Reklam Alanı',
    'removeAdsHint': 'Reklamları kaldırmak için dokun',
    'removeAds': 'Reklamları Kaldır',
    'subscriptionSection': 'Abonelik',
    'proActive': 'PRO Aktif',
    'proActiveDesc': 'Tüm premium özellikler açık',
    'proInactiveDesc': 'Tüm premium özelliklerin kilidini aç',

    // ── Dream Journal ──────────────────────────────────────────────────
    'dreamJournal': 'Rüya Günlüğü',
    'dreamJournalTitle': 'Rüya Günlüğü',
    'dreamJournalEmpty': 'Henüz rüya kaydı yok.\nRüyalarını kaydetmeye başla!',
    'dreamTotal': 'Toplam',
    'dreamLucid': 'Lusid',
    'dreamRecurring': 'Tekrarlayan',
    'dreamAddTitle': 'Rüya Kaydet',
    'dreamTitleHint': 'Rüya başlığı...',
    'dreamDescHint': 'Rüyanı anlat...',
    'dreamEmotions': 'Duygular',
    'dreamLucidity': 'Lusidlik',
    'dreamIsRecurring': 'Tekrarlayan rüya',
    'dreamSave': 'Rüyayı Kaydet',
    'dreamEmotionHappy': 'Mutlu',
    'dreamEmotionScared': 'Korkmuş',
    'dreamEmotionPeaceful': 'Huzurlu',
    'dreamEmotionConfused': 'Kafası karışık',
    'dreamEmotionExcited': 'Heyecanlı',
    'dreamEmotionSad': 'Üzgün',
    'dreamEmotionAnxious': 'Endişeli',
    'dreamEmotionNostalgic': 'Nostaljik',
    'all': 'Tümü',

    // ── Mood Tracker ───────────────────────────────────────────────────
    'moodTracker': 'Ruh Hali',
    'moodTrackerTitle': 'Ruh Hali Takibi',
    'moodTerrible': 'Berbat',
    'moodBad': 'Kötü',
    'moodNeutral': 'Normal',
    'moodGood': 'İyi',
    'moodGreat': 'Harika',
    'moodHowAreYou': 'Nasıl hissediyorsun?',
    'moodFactors': 'Ruh halini ne etkiledi?',
    'moodFactorExercise': 'Egzersiz',
    'moodFactorCaffeine': 'Kafein',
    'moodFactorStress': 'Stres',
    'moodFactorSocial': 'Sosyal',
    'moodFactorNature': 'Doğa',
    'moodFactorScreen': 'Ekran Süresi',
    'moodFactorMeditation': 'Meditasyon',
    'moodFactorAlcohol': 'Alkol',
    'moodNoteHint': 'Günün hakkında bir not ekle...',
    'moodSave': 'Ruh Halini Kaydet',
    'moodLoggedToday': 'Bugünün ruh hali kaydedildi!',
    'moodWeeklyTrend': 'Haftalık Trend',
    'moodHistory': 'Geçmiş',
    'moodNoEntries': 'Henüz ruh hali kaydı yok',
    'moodAverage': 'Ortalama',
    'moodStreak': 'Seri',
    'moodTotalLogs': 'Toplam',

    // ── Challenges ─────────────────────────────────────────────────────
    'challenges': 'Meydan Okuma',
    'challengesTitle': 'Uyku Meydan Okumaları',
    'challengeSleepDuration': '7+ Saat Uyu',
    'challengeSleepDurationDesc': 'Her gece en az 7 saat uyu',
    'challengeConsistency': 'Tutarlı Program',
    'challengeConsistencyDesc': 'Her gün aynı saatte yat',
    'challengeNoScreen': 'Ekransız Gece',
    'challengeNoScreenDesc': 'Yatmadan 1 saat önce ekran yok',
    'challengeEarlyBed': 'Erken Yatan',
    'challengeEarlyBedDesc': 'Saat 23:00\'den önce yat',
    'challengeMeditation': 'Zen Haftası',
    'challengeMeditationDesc': 'Her gün uyumadan önce meditasyon yap',
    'challengeNoSnooze': 'Erteleme Kahramanı',
    'challengeNoSnoozeDesc': 'Erteleme yapmadan uyan',
    'challengeXpEarned': 'Kazanılan XP',
    'challengeActive': 'Aktif Meydan Okumalar',
    'challengeAvailable': 'Mevcut Meydan Okumalar',
    'challengeCompleted': 'Tamamlanan',
    'challengeDays': 'gün',
    'challengeCheckIn': 'Giriş Yap',
    'challengeCheckedToday': 'Bugün yapıldı',
    'challengeStart': 'Başla',
    'challengeEarned': 'kazanıldı',

    // ── Sleep Timer ────────────────────────────────────────────────────
    'sleepTimer': 'Zamanlayıcı',
    'sleepTimerTitle': 'Uyku Zamanlayıcısı',
    'sleepTimerSelectDuration': 'Süre Seçin',
    'sleepTimerStart': 'Başlat',
    'sleepTimerFinished': 'Süre doldu! İyi uykular 🌙',
    'sleepTimerReset': 'Sıfırla',
    'sleepTimerTip':
        'Uykuya dalarken sesleriniz veya hikayeleriniz otomatik kapansın diye bir zamanlayıcı ayarlayın.',

    // ── Daily Tips ────────────────────────────────────────────────────
    'dailyTips': 'İpuçları',
    'dailyTipsTitle': 'Günlük Uyku İpuçları',
    'dailyTipsTodayPick': 'Bugünün Seçimleri',
    'dailyTipsSubtitle': 'Daha iyi uyku için her gün taze ipuçları',
    'dailyTipsToday': 'Bugünün İpuçları',
    'dailyTipsAll': 'Tüm İpuçları',
    'dt1Title': 'Tutarlı Program',
    'dt1Body': 'Hafta sonları dahil her gün aynı saatte yatın ve kalkın.',
    'dt2Title': 'Ekransız Bölge',
    'dt2Body': 'Yatmadan en az 30 dakika önce ekranları bırakın.',
    'dt3Title': 'Serin Oda',
    'dt3Body': 'Yatak odanızı optimal uyku için 15-19°C arasında tutun.',
    'dt4Title': 'Kafeini Sınırla',
    'dt4Body': 'Yatmadan en az 6 saat önce kafein almaktan kaçının.',
    'dt5Title': 'Günlük Egzersiz',
    'dt5Body':
        'Düzenli egzersiz uykuyu iyileştirir, ancak yoğun antrenmanlardan kaçının.',
    'dt6Title': 'Rahatlama Rutini',
    'dt6Body': 'Yatmadan önce derin nefes veya meditasyon yapın.',
    'dt7Title': 'Sabah Güneşi',
    'dt7Body': 'Sirkadiyen ritminizi düzenlemek için sabah doğal ışığa çıkın.',
    'dt8Title': 'Yatmadan Önce Oku',
    'dt8Body':
        'Yatmadan önce fiziksel bir kitap okumak rahatlayıp daha çabuk uyumanıza yardımcı olur.',
    'dt9Title': 'Sıcak Banyo',
    'dt9Body':
        'Yatmadan 1-2 saat önce sıcak banyo vücut ısınızı düşürmeye yardımcı olur.',
    'dt10Title': 'Hafif Akşam Yemeği',
    'dt10Body': 'Son büyük öğününüzü yatmadan en az 3 saat önce yiyin.',
    'dt11Title': 'Sakinleştirici Müzik',
    'dt11Body':
        'Uykuya hazırlanmak için sakin müzik veya doğa sesleri dinleyin.',
    'dt12Title': 'Rahat Yatak',
    'dt12Body':
        'Uyku pozisyonunuzu destekleyen iyi bir yatak ve yastığa yatırım yapın.',
    'dt13Title': 'Uyku Günlüğü',
    'dt13Body':
        'Zihninizi temizlemek için yatmadan önce düşüncelerinizi yazın.',
    'dt14Title': 'Yatak Odasında Bitki',
    'dt14Body':
        'Lavanta ve yasemin gibi bitkiler hava kalitesini artırıp rahatlamayı sağlar.',
    'dt15Title': 'Soğuk Duş',
    'dt15Body':
        'Kısa bir soğuk duş parasempatik sinir sisteminizi aktive ederek rahatlatır.',
    'dt16Title': '4-7-8 Nefes',
    'dt16Body':
        '4 saniye nefes alın, 7 saniye tutun, 8 saniye verin. 3 kez tekrarlayın.',
    'dt17Title': 'Sıcak Süt',
    'dt17Body': 'Sıcak süt, uykuyu teşvik eden triptofan içerir.',
    'dt18Title': 'Çorap Giyin',
    'dt18Body':
        'Sıcak ayaklar kan damarlarını genişletip beyne uyku zamanı sinyali verir.',
    'dt19Title': 'Alarm Kur',
    'dt19Body': 'Tutarlı kalkış saati, tutarlı yatış saatinden daha önemlidir.',
    'dt20Title': 'Aromaterapi',
    'dt20Body':
        'Lavanta esansiyel yağı rahatlamayı teşvik edip uyku kalitesini artırır.',
    'dt21Title': 'Şükran Pratiği',
    'dt21Body': 'Yatmadan önce minnettar olduğunuz 3 şeyi listeleyin.',
  };
}
