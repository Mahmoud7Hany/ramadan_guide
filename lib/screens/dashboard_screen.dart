import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة المهام'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              // تأكيد حذف جميع المهام
              bool? confirmed = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('حذف جميع المهام'),
                    content: Text('هل أنت متأكد أنك تريد حذف جميع المهام؟'),
                    actions: [
                      TextButton(
                        child: Text('إلغاء'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text('حذف'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                },
              );
              if (confirmed == true) {
                taskProvider.deleteAllTasks();
              }
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'لا توجد مهام حتى الآن. قم بإضافة مهمة!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                int completedValue = task.completedCount * task.dailyGoal;
                int remainingValue = task.monthlyGoal - completedValue;
                if (remainingValue < 0) remainingValue = 0;
                double progressPercentage = (task.progress * 100).clamp(0, 100);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تم إنجاز: $completedValue - المتبقي: $remainingValue',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.teal,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'نسبة الإنجاز: ${progressPercentage.toStringAsFixed(1)}%',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر الحذف مع نافذة تأكيد
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            bool? confirmed = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('حذف المهمة'),
                                  content: Text(
                                      'هل أنت متأكد أنك تريد حذف هذه المهمة؟'),
                                  actions: [
                                    TextButton(
                                      child: Text('إلغاء'),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    TextButton(
                                      child: Text('حذف'),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmed == true) {
                              taskProvider.deleteTask(task.id);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // الانتقال إلى شاشة تفاصيل المهمة عند الضغط عليها
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
