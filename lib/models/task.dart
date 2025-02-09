import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  int monthlyGoal;
  int dailyGoal;
  Map<int, bool> completedDays;

  Task({
    required this.title,
    required this.monthlyGoal,
    String? id,
    int? dailyGoal,
    Map<int, bool>? completedDays,
  })  : id = id ?? Uuid().v4(),
        dailyGoal = dailyGoal ?? (monthlyGoal / 30).ceil(),
        completedDays = completedDays ?? {for (int i = 1; i <= 30; i++) i: false};

  // حساب عدد الأيام المكتملة
  int get completedCount => completedDays.values.where((done) => done).length;

  // حساب نسبة الإنجاز
  double get progress => completedCount / 30;

  // تحويل المهمة إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'monthlyGoal': monthlyGoal,
      'dailyGoal': dailyGoal,
      // تحويل مفاتيح الخريطة إلى String لأنها لا تدعم المفاتيح من نوع int
      'completedDays': completedDays.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  // إنشاء مهمة من JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> compDaysJson = json['completedDays'];
    Map<int, bool> compDays = compDaysJson.map((key, value) => MapEntry(int.parse(key), value as bool));
    return Task(
      id: json['id'],
      title: json['title'],
      monthlyGoal: json['monthlyGoal'],
      dailyGoal: json['dailyGoal'],
      completedDays: compDays,
    );
  }
}
