import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class LearningState extends Equatable {
  const LearningState({
    this.articles = const [],
    this.filteredArticles = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.searchQuery = '',
  });

  final List<SleepTipModel> articles;
  final List<SleepTipModel> filteredArticles;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final String searchQuery;

  LearningState copyWith({
    List<SleepTipModel>? articles,
    List<SleepTipModel>? filteredArticles,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return LearningState(
      articles: articles ?? this.articles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    articles,
    filteredArticles,
    isLoading,
    error,
    selectedCategory,
    searchQuery,
  ];
}
