// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SleepyApp';

  @override
  String get tagline => 'Sleep Better. Live Better.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get sounds => 'Sounds';

  @override
  String get learning => 'Learning';

  @override
  String get profile => 'Profile';

  @override
  String get goodNight => 'Good Night';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String greeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get sleepScore => 'Sleep Score';

  @override
  String get sleepDuration => 'Sleep Duration';

  @override
  String get sleepGoal => 'Sleep Goal';

  @override
  String get avgSleep => 'Weekly Average';

  @override
  String get sleepDebt => 'Sleep Debt';

  @override
  String get trackSleep => 'Track Sleep';

  @override
  String get stopTracking => 'Stop Tracking';

  @override
  String get startTracking => 'Start Tracking';

  @override
  String get tracking => 'Tracking...';

  @override
  String get logSleep => 'Log Sleep';

  @override
  String get sleepHistory => 'Sleep History';

  @override
  String get noRecords => 'No sleep records yet';

  @override
  String get soundLibrary => 'Sound Library';

  @override
  String get aiMoodMusic => 'AI Mood Music';

  @override
  String get mixer => 'Mixer';

  @override
  String get noActiveTracks => 'No active tracks';

  @override
  String get addSounds => 'Add sounds to mixer';

  @override
  String get moodInputHint => 'Describe your mood...';

  @override
  String get getRecommendations => 'Get Recommendations';

  @override
  String get articles => 'Articles';

  @override
  String get searchArticles => 'Search articles...';

  @override
  String get all => 'All';

  @override
  String minRead(int min) {
    return '$min min read';
  }

  @override
  String get rewards => 'Rewards';

  @override
  String get myBadges => 'My Badges';

  @override
  String get earned => 'Earned';

  @override
  String get locked => 'Locked';

  @override
  String get feedback => 'Feedback';

  @override
  String get howWasApp => 'How was SleepyApp?';

  @override
  String get ratingLabel => 'Your Rating';

  @override
  String get messagePlaceholder => 'Share your thoughts... (optional)';

  @override
  String get submit => 'Submit';

  @override
  String get thankYou => 'Thank You! 🙏';

  @override
  String get feedbackSent => 'Your feedback was submitted successfully.';

  @override
  String get pro => 'PRO';

  @override
  String get sleepyAppPro => 'SleepyApp PRO';

  @override
  String get proTagline => 'Premium experience for better sleep';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get perMonth => 'per month';

  @override
  String perYear(int discount) {
    return 'per year ($discount% off)';
  }

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get subscriptionNote =>
      'Subscription renews automatically. Cancel anytime.';

  @override
  String get proActive => '🎉 Welcome to PRO! All features unlocked.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get sleepReminder => 'Sleep Reminder';

  @override
  String get sleepReminderSub => 'Get notified at bedtime';

  @override
  String get sleepSchedule => 'Sleep Schedule';

  @override
  String get bedtime => 'Bedtime';

  @override
  String get sleepGoalHours => 'Sleep Goal';

  @override
  String get account => 'Account';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String version(String version) {
    return 'SleepyApp v$version';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get resetPasswordSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';
}
