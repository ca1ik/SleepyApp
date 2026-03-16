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
      description:
          'Uyku-uyaniklik döngünüzü yöneten iç saatiniz hakkinda her sey.',
      emoji: '⏰',
      category: 'Biyoloji',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '2',
      title: 'Ekran Magarasi Sendromu',
      description: 'Mavi isik uykuyu nasil etkiler ve nasil korunabilirsiniz.',
      emoji: '📱',
      category: 'Teknoloji',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '3',
      title: 'Derin Uyku Evreleri',
      description: 'REM ve NREM uyku evrelerinde beyin ne yapar?',
      emoji: '🧠',
      category: 'Biyoloji',
      readTimeMinutes: 6,
    ),
    const SleepTipModel(
      id: '4',
      title: 'Kafein ve Uyku',
      description: 'Kafein ne zaman kesilebilir? Yari omür nedir?',
      emoji: '☕',
      category: 'Beslenme',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '5',
      title: 'Serin Ortamda Daha Iyi Uyu',
      description: 'Ideal uyku odasi sicakligini nasil ayarlayabilirsiniz.',
      emoji: '❄️',
      category: 'Ortam',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '6',
      title: '4-7-8 Nefes Teknigi',
      description: 'Birkaç dakikada uyumanizi saglayan güclü bir teknik.',
      emoji: '🌬️',
      category: 'Teknik',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '7',
      title: 'Spor ve Uyku Kalitesi',
      description: 'Hangi antrenman türü uyku kalitesini en çok arttirir?',
      emoji: '🏃',
      category: 'Spor',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '8',
      title: 'Stres Uyku Düsmanı',
      description: 'Kortizol seviyesi uyku üzerinde nasil olumsuz etki yapar?',
      emoji: '😰',
      category: 'Psikoloji',
      readTimeMinutes: 5,
    ),
    const SleepTipModel(
      id: '9',
      title: 'Melatonin Takviyesi',
      description:
          'Melatonin ne zaman ve nasil kullanilir? Dogal üretimi artirmanin yollari.',
      emoji: '💊',
      category: 'Beslenme',
      readTimeMinutes: 4,
    ),
    const SleepTipModel(
      id: '10',
      title: 'Uyku Hijyeni 101',
      description: 'Saglikli uyku aliniskanliklarinin temel kurallari.',
      emoji: '🛏️',
      category: 'Hijyen',
      readTimeMinutes: 6,
    ),
    const SleepTipModel(
      id: '11',
      title: 'Power Nap Bilimi',
      description: '20 dakikalik bir uyku neden bu kadar etkilidir?',
      emoji: '⚡',
      category: 'Teknik',
      readTimeMinutes: 3,
    ),
    const SleepTipModel(
      id: '12',
      title: 'Kisisel Uyku Profili',
      description:
          'Sabah insani mi gece kusu musunuz? Kronotipinizi kesfleyin.',
      emoji: '🦉',
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
                    a.description.toLowerCase().contains(q),
              )
              .toList();
    emit(state.copyWith(filteredArticles: filtered, searchQuery: query));
  }
}
