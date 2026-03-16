/// API endpoint sabitleri ve base URL.
abstract final class ApiConstants {
  // Base URL (production) — .env ile override edilebilir
  static const String baseUrl = 'https://api.sleepyapp.example.com/v1';

  // Mock/dev URL (json-server veya postman mock)
  static const String mockBaseUrl =
      'https://my-json-server.typicode.com/sleepyapp/mock';

  // Timeouts
  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 15000;
  static const int sendTimeoutMs = 10000;

  // Endpoints
  static const String sleepTips = '/sleep-tips';
  static const String moodSuggestion = '/mood-suggestion';
  static const String aiStory = '/ai-story';
  static const String aiLullaby = '/ai-lullaby';
  static const String chatbot = '/chatbot';
  static const String userProfile = '/user/profile';
  static const String sleepLogs = '/sleep-logs';
  static const String weeklyReport = '/reports/weekly';

  // Header Keys
  static const String headerAuth = 'Authorization';
  static const String headerContentType = 'Content-Type';
  static const String headerAccept = 'Accept';
  static const String headerAppVersion = 'X-App-Version';
  static const String headerPlatform = 'X-Platform';

  ApiConstants._();
}
