import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/dream_journal/domain/dream_models.dart';

enum DreamJournalStatus { initial, loaded, saving }

class DreamJournalState extends Equatable {
  const DreamJournalState({
    this.status = DreamJournalStatus.initial,
    this.dreams = const [],
    this.filterEmotion,
  });

  final DreamJournalStatus status;
  final List<DreamEntry> dreams;
  final DreamEmotion? filterEmotion;

  int get totalDreams => dreams.length;
  int get lucidDreams => dreams.where((d) => d.lucidityLevel >= 3).length;
  int get recurringDreams => dreams.where((d) => d.isRecurring).length;

  List<DreamEntry> get filteredDreams {
    if (filterEmotion == null) return dreams;
    return dreams.where((d) => d.emotions.contains(filterEmotion)).toList();
  }

  DreamJournalState copyWith({
    DreamJournalStatus? status,
    List<DreamEntry>? dreams,
    DreamEmotion? Function()? filterEmotion,
  }) {
    return DreamJournalState(
      status: status ?? this.status,
      dreams: dreams ?? this.dreams,
      filterEmotion:
          filterEmotion != null ? filterEmotion() : this.filterEmotion,
    );
  }

  @override
  List<Object?> get props => [status, dreams, filterEmotion];
}
