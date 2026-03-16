import 'package:equatable/equatable.dart';

/// Kullanıcı entity — domain katmanı
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isPro = false,
    this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isPro;
  final DateTime? createdAt;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isPro,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPro: isPro ?? this.isPro,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isPro': isPro,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      isPro: map['isPro'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    isPro,
    createdAt,
  ];
}

/// Uyku kaydı entity — domain katmanı
class SleepEntity extends Equatable {
  const SleepEntity({
    required this.id,
    required this.userId,
    required this.bedtime,
    required this.wakeTime,
    required this.date,
    this.qualityScore = 0,
    this.disturbanceCount = 0,
    this.hadDeepSleep = false,
    this.notes,
  });

  final String id;
  final String userId;
  final DateTime bedtime;
  final DateTime wakeTime;
  final DateTime date;
  final int qualityScore;
  final int disturbanceCount;
  final bool hadDeepSleep;
  final String? notes;

  Duration get duration => wakeTime.difference(bedtime).isNegative
      ? wakeTime.add(const Duration(days: 1)).difference(bedtime)
      : wakeTime.difference(bedtime);

  SleepEntity copyWith({
    String? id,
    String? userId,
    DateTime? bedtime,
    DateTime? wakeTime,
    DateTime? date,
    int? qualityScore,
    int? disturbanceCount,
    bool? hadDeepSleep,
    String? notes,
  }) {
    return SleepEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      date: date ?? this.date,
      qualityScore: qualityScore ?? this.qualityScore,
      disturbanceCount: disturbanceCount ?? this.disturbanceCount,
      hadDeepSleep: hadDeepSleep ?? this.hadDeepSleep,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bedtime': bedtime.toIso8601String(),
      'wakeTime': wakeTime.toIso8601String(),
      'date': date.toIso8601String(),
      'qualityScore': qualityScore,
      'disturbanceCount': disturbanceCount,
      'hadDeepSleep': hadDeepSleep,
      'notes': notes,
    };
  }

  factory SleepEntity.fromMap(Map<String, dynamic> map) {
    return SleepEntity(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      bedtime: DateTime.parse(map['bedtime'] as String),
      wakeTime: DateTime.parse(map['wakeTime'] as String),
      date: DateTime.parse(map['date'] as String),
      qualityScore: map['qualityScore'] as int? ?? 0,
      disturbanceCount: map['disturbanceCount'] as int? ?? 0,
      hadDeepSleep: map['hadDeepSleep'] as bool? ?? false,
      notes: map['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    bedtime,
    wakeTime,
    date,
    qualityScore,
    disturbanceCount,
    hadDeepSleep,
    notes,
  ];
}
