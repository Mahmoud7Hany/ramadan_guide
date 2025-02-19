class Task {
  final String id;
  final String title;
  final int monthlyGoal;
  final int dailyGoal;
  final DateTime startDate;
  final DateTime createdAt;
  final Map<String, bool> completedDays;

  Task({
    required this.id,
    required this.title,
    required this.monthlyGoal,
    required this.dailyGoal,
    required this.startDate,
    DateTime? createdAt,
    Map<String, bool>? completedDays,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    completedDays = completedDays ?? {};

  double get progress => completedCount / 30;
  
  int get completedCount => completedDays.values.where((v) => v).length;
  
  int get remainingValue => (monthlyGoal - (completedCount * dailyGoal)).clamp(0, double.infinity).toInt();
  
  double get progressPercentage => (progress * 100).clamp(0, 100);
  
  int get remainingDays => 30 - completedCount;
  
  int get requiredDailyRate => remainingValue > 0 && remainingDays > 0 
      ? (remainingValue / remainingDays).ceil() 
      : 0;

  Task copyWith({
    String? id,
    String? title,
    int? monthlyGoal,
    int? dailyGoal,
    DateTime? startDate,
    DateTime? createdAt,
    Map<String, bool>? completedDays,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      completedDays: completedDays ?? Map.from(this.completedDays),
    );
  }

  Task toggleDay(String date) {
    final newCompletedDays = Map<String, bool>.from(completedDays);
    newCompletedDays[date] = !(completedDays[date] ?? false);
    return copyWith(completedDays: newCompletedDays);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'monthlyGoal': monthlyGoal,
      'dailyGoal': dailyGoal,
      'startDate': startDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedDays': completedDays,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      monthlyGoal: json['monthlyGoal'],
      dailyGoal: json['dailyGoal'],
      startDate: DateTime.parse(json['startDate']),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedDays: Map<String, bool>.from(json['completedDays'] ?? {}),
    );
  }
}
