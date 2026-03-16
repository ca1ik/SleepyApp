import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'SleepyApp'**
  String get appName;

  /// App tagline
  ///
  /// In en, this message translates to:
  /// **'Sleep Better. Live Better.'**
  String get tagline;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String greeting(String name);

  /// No description provided for @sleepScore.
  ///
  /// In en, this message translates to:
  /// **'Sleep Score'**
  String get sleepScore;

  /// No description provided for @sleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Sleep Duration'**
  String get sleepDuration;

  /// No description provided for @sleepGoal.
  ///
  /// In en, this message translates to:
  /// **'Sleep Goal'**
  String get sleepGoal;

  /// No description provided for @avgSleep.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average'**
  String get avgSleep;

  /// No description provided for @sleepDebt.
  ///
  /// In en, this message translates to:
  /// **'Sleep Debt'**
  String get sleepDebt;

  /// No description provided for @trackSleep.
  ///
  /// In en, this message translates to:
  /// **'Track Sleep'**
  String get trackSleep;

  /// No description provided for @stopTracking.
  ///
  /// In en, this message translates to:
  /// **'Stop Tracking'**
  String get stopTracking;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTracking;

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking...'**
  String get tracking;

  /// No description provided for @logSleep.
  ///
  /// In en, this message translates to:
  /// **'Log Sleep'**
  String get logSleep;

  /// No description provided for @sleepHistory.
  ///
  /// In en, this message translates to:
  /// **'Sleep History'**
  String get sleepHistory;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No sleep records yet'**
  String get noRecords;

  /// No description provided for @soundLibrary.
  ///
  /// In en, this message translates to:
  /// **'Sound Library'**
  String get soundLibrary;

  /// No description provided for @aiMoodMusic.
  ///
  /// In en, this message translates to:
  /// **'AI Mood Music'**
  String get aiMoodMusic;

  /// No description provided for @mixer.
  ///
  /// In en, this message translates to:
  /// **'Mixer'**
  String get mixer;

  /// No description provided for @noActiveTracks.
  ///
  /// In en, this message translates to:
  /// **'No active tracks'**
  String get noActiveTracks;

  /// No description provided for @addSounds.
  ///
  /// In en, this message translates to:
  /// **'Add sounds to mixer'**
  String get addSounds;

  /// No description provided for @moodInputHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your mood...'**
  String get moodInputHint;

  /// No description provided for @getRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendations'**
  String get getRecommendations;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @searchArticles.
  ///
  /// In en, this message translates to:
  /// **'Search articles...'**
  String get searchArticles;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @minRead.
  ///
  /// In en, this message translates to:
  /// **'{min} min read'**
  String minRead(int min);

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @myBadges.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get myBadges;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @howWasApp.
  ///
  /// In en, this message translates to:
  /// **'How was SleepyApp?'**
  String get howWasApp;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get ratingLabel;

  /// No description provided for @messagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts... (optional)'**
  String get messagePlaceholder;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You! 🙏'**
  String get thankYou;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Your feedback was submitted successfully.'**
  String get feedbackSent;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pro;

  /// No description provided for @sleepyAppPro.
  ///
  /// In en, this message translates to:
  /// **'SleepyApp PRO'**
  String get sleepyAppPro;

  /// No description provided for @proTagline.
  ///
  /// In en, this message translates to:
  /// **'Premium experience for better sleep'**
  String get proTagline;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'per year ({discount}% off)'**
  String perYear(int discount);

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @subscriptionNote.
  ///
  /// In en, this message translates to:
  /// **'Subscription renews automatically. Cancel anytime.'**
  String get subscriptionNote;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'🎉 Welcome to PRO! All features unlocked.'**
  String get proActive;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @sleepReminder.
  ///
  /// In en, this message translates to:
  /// **'Sleep Reminder'**
  String get sleepReminder;

  /// No description provided for @sleepReminderSub.
  ///
  /// In en, this message translates to:
  /// **'Get notified at bedtime'**
  String get sleepReminderSub;

  /// No description provided for @sleepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Sleep Schedule'**
  String get sleepSchedule;

  /// No description provided for @bedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtime;

  /// No description provided for @sleepGoalHours.
  ///
  /// In en, this message translates to:
  /// **'Sleep Goal'**
  String get sleepGoalHours;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'SleepyApp v{version}'**
  String version(String version);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmail;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get resetPasswordSent;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
