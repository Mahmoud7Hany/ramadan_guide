import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  
  const TaskDetailScreen({super.key, required this.task});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // الحصول على نسخة محدثة من المهمة باستخدام الـ id
        final updatedTask = taskProvider.tasks.firstWhere((t) => t.id == task.id);
        int completedDays = updatedTask.completedCount;
        int dailyGoal = updatedTask.dailyGoal;
        int monthlyGoal = updatedTask.monthlyGoal;
        int completedValue = completedDays * dailyGoal;
        int remainingValue = monthlyGoal - completedValue;
        if (remainingValue < 0) remainingValue = 0;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(updatedTask.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    int day = index + 1;
                    bool isCompleted = updatedTask.completedDays[day] ?? false;
                    return CheckboxListTile(
                      title: Text('اليوم $day'),
                      value: isCompleted,
                      onChanged: (value) {
                        // عند الضغط على checkbox يتم تحديث حالة اليوم فوراً
                        taskProvider.toggleTaskDay(updatedTask.id, day);
                      },
                    );
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('الهدف الشهري: $monthlyGoal', style: TextStyle(fontSize: 18)),
                    Text('المعدل اليومي: $dailyGoal', style: TextStyle(fontSize: 18)),
                    Text('تم إنجاز: $completedValue', style: TextStyle(fontSize: 18)),
                    Text('المتبقي: $remainingValue', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
