import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class LearningCubit extends Cubit<LearningState> {
  LearningCubit() : super(const LearningState()) {
    _loadArticles();
  }

  static final List<SleepTipModel> _articles = [
    const SleepTipModel(
      id: '1',
      title: 'Sirkadiyen Ritim Nedir?',
      body: 'Uyku-uyaniklik dongununuzu yoneten ic saatiniz hakkinda her sey.',
      category: 'Biyoloji',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '2',
      title: 'Ekran Magarasi Sendromu',
      body: 'Mavi isik uykuyu nasil etkiler ve nasil korunabilirsiniz.',
      category: 'Teknoloji',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '3',
      title: 'Derin Uyku Evreleri',
      body: 'REM ve NREM uyku evrelerinde beyin ne yapar?',
      category: 'Biyoloji',
      readTimeMinutes: 6,
    ),
    const SleepTipModel(
      id: '4',
      title: 'Kafein ve Uyku',
      body: 'Kafein ne zaman kesilebilir? Yari omur nedir?',
      category: 'Beslenme',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '5',
      title: 'Serin Ortamda Daha Iyi Uyu',
      body: 'Ideal uyku odasi sicakligini nasil ayarlayabilirsiniz.',
      category: 'Ortam',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '6',
      title: '4-7-8 Nefes Teknigi',
      body: 'Birkaç dakikada uyumanizi saglayan guclu bir teknik.',
      category: 'Teknik',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '7',
      title: 'Spor ve Uyku Kalitesi',
      body: 'Hangi antrenman turu uyku kalitesini en cok arttirir?',
      category: 'Spor',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '8',
      title: 'Stres Uyku Dusmani',
      body: 'Kortizol seviyesi uyku uzerinde nasil olumsuz etki yapar?',
      category: 'Psikoloji',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '9',
      title: 'Melatonin Takviyesi',
      body:
          'Melatonin ne zaman ve nasil kullanilir? Dogal uretimi artirmanin yollari.',
      category: 'Beslenme',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '10',
      title: 'Uyku Hijyeni 101',
      body: 'Saglikli uyku aliniskanliklarinin temel kurallari.',
      category: 'Hijyen',
      readTimeMinutes: 6,
    ),
    const SleepTipModel(
      id: '11',
      title: 'Power Nap Bilimi',
      body: '20 dakikalik bir uyku neden bu kadar etkilidir?',
      category: 'Teknik',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '12',
      title: 'Kisisel Uyku Profili',
      body: 'Sabah insani mi gece kusu musunuz? Kronotipinizi kesfleyin.',
      category: 'Biyoloji',
      readTimeMinutes: 4,
    ),
  ];

  void _loadArticles() {
    emit(state.copyWith(articles: _articles, filteredArticles: _articles));
  }

  void filterByCategory(String? category) {
    final filtered = category == null
        ? _articles
        : _articles.where((a) => a.category == category).toList();
    emit(
      state.copyWith(
        filteredArticles: filtered,
        selectedCategory: category,
        clearCategory: category == null,
      ),
    );
  }

  void search(String query) {
    final q = query.toLowerCase();
    final filtered = q.isEmpty
        ? _articles
        : _articles
              .where(
                (a) =>
                    a.title.toLowerCase().contains(q) ||
                    a.body.toLowerCase().contains(q),
              )
              .toList();
    emit(state.copyWith(filteredArticles: filtered, searchQuery: query));
  }
}