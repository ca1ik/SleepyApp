// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'SleepyApp';

  @override
  String get tagline => 'Daha İyi Uyu. Daha İyi Yaşa.';

  @override
  String get dashboard => 'Ana Sayfa';

  @override
  String get sounds => 'Sesler';

  @override
  String get learning => 'Öğren';

  @override
  String get profile => 'Profil';

  @override
  String get goodNight => 'İyi Geceler';

  @override
  String get goodMorning => 'Günaydın';

  @override
  String greeting(String name) {
    return 'Merhaba, $name!';
  }

  @override
  String get sleepScore => 'Uyku Skoru';

  @override
  String get sleepDuration => 'Uyku Süresi';

  @override
  String get sleepGoal => 'Uyku Hedefi';

  @override
  String get avgSleep => 'Haftalık Ortalama';

  @override
  String get sleepDebt => 'Uyku Borcu';

  @override
  String get trackSleep => 'Uyku Takibi';

  @override
  String get stopTracking => 'Takibi Durdur';

  @override
  String get startTracking => 'Takibe Başla';

  @override
  String get tracking => 'Takip Ediliyor...';

  @override
  String get logSleep => 'Uyku Kaydet';

  @override
  String get sleepHistory => 'Uyku Geçmişi';

  @override
  String get noRecords => 'Henüz uyku kaydı yok';

  @override
  String get soundLibrary => 'Ses Kütüphanesi';

  @override
  String get aiMoodMusic => 'YZ Mod Müziği';

  @override
  String get mixer => 'Karıştırıcı';

  @override
  String get noActiveTracks => 'Aktif parça yok';

  @override
  String get addSounds => 'Karıştırıcıya ses ekle';

  @override
  String get moodInputHint => 'Ruh halini anlat...';

  @override
  String get getRecommendations => 'Öneri Getir';

  @override
  String get articles => 'Makaleler';

  @override
  String get searchArticles => 'Makale ara...';

  @override
  String get all => 'Tümü';

  @override
  String minRead(int min) {
    return '$min dk okuma';
  }

  @override
  String get rewards => 'Ödüller';

  @override
  String get myBadges => 'Rozetlerim';

  @override
  String get earned => 'Kazanıldı';

  @override
  String get locked => 'Kilitli';

  @override
  String get feedback => 'Geri Bildirim';

  @override
  String get howWasApp => 'SleepyApp\'i nasıl buldunuz?';

  @override
  String get ratingLabel => 'Puanınız';

  @override
  String get messagePlaceholder => 'Düşüncelerinizi paylaşın... (isteğe bağlı)';

  @override
  String get submit => 'Gönder';

  @override
  String get thankYou => 'Teşekkürler! 🙏';

  @override
  String get feedbackSent => 'Geri bildiriminiz başarıyla iletildi.';

  @override
  String get pro => 'PRO';

  @override
  String get sleepyAppPro => 'SleepyApp PRO';

  @override
  String get proTagline => 'Daha iyi uyku için premium deneyim';

  @override
  String get monthly => 'Aylık Plan';

  @override
  String get yearly => 'Yıllık Plan';

  @override
  String get perMonth => 'aylık';

  @override
  String perYear(int discount) {
    return 'yıllık (%$discount indirim)';
  }

  @override
  String get restorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get subscriptionNote =>
      'Abonelik otomatik yenilenir. İstediğiniz zaman iptal edebilirsiniz.';

  @override
  String get proActive =>
      '🎉 PRO\'ya hoş geldin! Tüm özellikler kilidini açtı.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil / Language';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get sleepReminder => 'Uyku Hatırlatıcı';

  @override
  String get sleepReminderSub => 'Yatma saatinde bildirim al';

  @override
  String get sleepSchedule => 'Uyku Programı';

  @override
  String get bedtime => 'Yatma Saati';

  @override
  String get sleepGoalHours => 'Uyku Hedefi';

  @override
  String get account => 'Hesap';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Kullanım Koşulları';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get logoutConfirm => 'Hesabından çıkmak istediğine emin misin?';

  @override
  String get cancel => 'İptal';

  @override
  String get ok => 'Tamam';

  @override
  String version(String version) {
    return 'SleepyApp v$version';
  }

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifre Tekrar';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get forgotPassword => 'Şifremi Unuttum?';

  @override
  String get sendResetEmail => 'Sıfırlama E-postası Gönder';

  @override
  String get dontHaveAccount => 'Hesabın yok mu?';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get resetPasswordSent =>
      'Şifre sıfırlama e-postası gönderildi. Gelen kutunu kontrol et.';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get back => 'Geri';
}
