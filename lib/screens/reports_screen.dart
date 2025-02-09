import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

// صفحه التقارير
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        int completedValue = task.completedCount * task.dailyGoal;
        int remainingValue = task.monthlyGoal - completedValue;
        if (remainingValue < 0) remainingValue = 0;
        return Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(
              'تم إنجاز: $completedValue - المتبقي: $remainingValue',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
