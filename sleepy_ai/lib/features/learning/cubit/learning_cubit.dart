import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class LearningCubit extends Cubit<LearningState> {
  LearningCubit() : super(const LearningState()) {
    _loadArticles();
  }

  static List<SleepTipModel> get _articles => [
        SleepTipModel(
          id: '1',
          title: 'articleCircadian'.tr,
          body: 'articleCircadianBody'.tr,
          category: 'catBiology'.tr,
          readTimeMinutes: 5,
        ),
        SleepTipModel(
          id: '2',
          title: 'articleScreen'.tr,
          body: 'articleScreenBody'.tr,
          category: 'catTechnology'.tr,
          readTimeMinutes: 4,
        ),
        SleepTipModel(
          id: '3',
          title: 'articleDeepSleep'.tr,
          body: 'articleDeepSleepBody'.tr,
          category: 'catBiology'.tr,
          readTimeMinutes: 6,
        ),
        SleepTipModel(
          id: '4',
          title: 'articleCaffeine'.tr,
          body: 'articleCaffeineBody'.tr,
          category: 'catNutrition'.tr,
          readTimeMinutes: 3,
        ),
        SleepTipModel(
          id: '5',
          title: 'articleCoolRoom'.tr,
          body: 'articleCoolRoomBody'.tr,
          category: 'catEnvironment'.tr,
          readTimeMinutes: 3,
        ),
        SleepTipModel(
          id: '6',
          title: 'articleBreathing'.tr,
          body: 'articleBreathingBody'.tr,
          category: 'catTechnique'.tr,
          readTimeMinutes: 4,
        ),
        SleepTipModel(
          id: '7',
          title: 'articleExercise'.tr,
          body: 'articleExerciseBody'.tr,
          category: 'catSports'.tr,
          readTimeMinutes: 5,
        ),
        SleepTipModel(
          id: '8',
          title: 'articleStress'.tr,
          body: 'articleStressBody'.tr,
          category: 'catPsychology'.tr,
          readTimeMinutes: 5,
        ),
        SleepTipModel(
          id: '9',
          title: 'articleMelatonin'.tr,
          body: 'articleMelatoninBody'.tr,
          category: 'catNutrition'.tr,
          readTimeMinutes: 4,
        ),
        SleepTipModel(
          id: '10',
          title: 'articleHygiene'.tr,
          body: 'articleHygieneBody'.tr,
          category: 'catHygiene'.tr,
          readTimeMinutes: 6,
        ),
        SleepTipModel(
          id: '11',
          title: 'articlePowerNap'.tr,
          body: 'articlePowerNapBody'.tr,
          category: 'catTechnique'.tr,
          readTimeMinutes: 3,
        ),
        SleepTipModel(
          id: '12',
          title: 'articleChronotype'.tr,
          body: 'articleChronotypeBody'.tr,
          category: 'catBiology'.tr,
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
