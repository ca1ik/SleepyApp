import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'tr': _tr,
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
    'yourSleepScore': 'Your Sleep Score',
    'earned': '✓ Earned',
    'earnedCount': 'Earned (@count)',

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

    // ── Breathing Game ────────────────────────────────────────────────
    'awesome': 'Awesome!',
    'cyclesCompleted': '@cycles cycles completed',
    'points': 'POINTS',
    'cosmicBreathBadge': '"Cosmic Breath" badge earned!',
    'playAgain': 'Play Again',
    'backToGames': 'Back to Games',

    // ── Sheep Counter ─────────────────────────────────────────────────
    'sheepTitle': 'Sheep Counting',
    'sleepTime': 'Sleep time… 💤',
    'sheepCounted': 'Sheep Counted',
    'score': 'Score',
    'badgeThreshold': 'Badge Threshold',
    'thirtySheep': '30 sheep',
    'badgeEarned': 'Badge Earned!',
    'sleepySheep': 'Sleepy Sheep',
    'again': 'Again',

    // ── Bubble Pop ────────────────────────────────────────────────────
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
    'caughtStars': 'Caught Stars',
    'targetScore': 'Target score',
    'threeHundredPoints': '300 points',
    'starCatcherBadge': 'Star Catcher',

    // ── Sleep Films ───────────────────────────────────────────────────
    'filmCompleted': 'Film completed ✨',
    'swipeForNext': 'Swipe right for next scene →',
    'dreamWeaver': 'Dream Weaver',
    'filmList': 'Film List',
    'sleepFilmsAppbar': 'Sleep Films',
    'filmsCount': '@count soothing animations • 2-3 minutes',

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
    'yourSleepScore': 'Uyku Puanın',
    'earned': '✓ Kazanıldı',
    'earnedCount': 'Kazanılanlar (@count)',

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

    // ── Breathing Game ────────────────────────────────────────────────
    'awesome': 'Harika!',
    'cyclesCompleted': '@cycles döngü tamamladın',
    'points': 'PUAN',
    'cosmicBreathBadge': '"Kozmik Nefes" rozeti kazanıldı!',
    'playAgain': 'Tekrar Oyna',
    'backToGames': 'Oyunlar\'a Dön',

    // ── Sheep Counter ─────────────────────────────────────────────────
    'sheepTitle': 'Koyun Sayma',
    'sleepTime': 'Uyku vakti… 💤',
    'sheepCounted': 'Sayılan Koyun',
    'score': 'Puan',
    'badgeThreshold': 'Rozet Eşiği',
    'thirtySheep': '30 koyun',
    'badgeEarned': 'Rozet Kazanıldı!',
    'sleepySheep': 'Uykulu Koyun',
    'again': 'Tekrar',

    // ── Bubble Pop ────────────────────────────────────────────────────
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
    'caughtStars': 'Yakalanan Yıldız',
    'targetScore': 'Hedef puan',
    'threeHundredPoints': '300 puan',
    'starCatcherBadge': 'Yıldız Avcısı',

    // ── Sleep Films ───────────────────────────────────────────────────
    'filmCompleted': 'Film tamamlandı ✨',
    'swipeForNext': 'Sonraki sahne için sağa kaydır →',
    'dreamWeaver': 'Rüya Dokuyucu',
    'filmList': 'Film Listesi',
    'sleepFilmsAppbar': 'Uyku Filmleri',
    'filmsCount': '@count adet huzur verici animasyon • 2-3 dakika',

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
  };
}
