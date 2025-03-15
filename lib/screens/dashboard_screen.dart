// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/animated_card.dart';
import '../widgets/task_statistics.dart';
import 'task_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          if (tasks.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 18,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'المهام النشطة: ${tasks.length}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              const Text('حذف جميع المهام'),
                            ],
                          ),
                          content: const Text('هل أنت متأكد من حذف جميع المهام؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                              ),
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        taskProvider.deleteAllTasks();
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('حذف الكل'),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.task_alt,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد مهام',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'قم بإضافة مهمة جديدة للبدء في تتبع عباداتك',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final completedValue = task.completedCount * task.dailyGoal;
                      final remainingValue = task.remainingValue;
                      final progressPercentage = task.progressPercentage;
                      final dailyRequired = task.requiredDailyRate;
                      final remainingDays = task.remainingDays;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedCard(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TaskDetailScreen(task: task),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.lerp(
                                        theme.colorScheme.primary,
                                        theme.colorScheme.surface,
                                        0.85) ?? theme.colorScheme.surface,
                                      theme.colorScheme.surface,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.shadow.withOpacity(0.08),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                      spreadRadius: -3,
                                    ),
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withOpacity(0.08),
                                      blurRadius: 25,
                                      offset: const Offset(0, 8),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  theme.colorScheme.primary.withOpacity(0.2),
                                                  theme.colorScheme.primaryContainer.withOpacity(0.3),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                  spreadRadius: -2,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.mosque,
                                              color: theme.colorScheme.onPrimaryContainer,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'متبقي $remainingDays يوم',
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            color: theme.colorScheme.error,
                                            onPressed: () async {
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('حذف المهمة'),
                                                  content: const Text('هل أنت متأكد من حذف هذه المهمة؟'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: const Text('إلغاء'),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      style: FilledButton.styleFrom(
                                                        backgroundColor: theme.colorScheme.error,
                                                      ),
                                                      child: const Text('حذف'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirmed == true) {
                                                taskProvider.deleteTask(task.id);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      TaskStatistics(
                                        completedValue: completedValue,
                                        remainingValue: remainingValue,
                                        monthlyGoal: task.monthlyGoal,
                                        dailyRequired: dailyRequired,
                                        progressPercentage: progressPercentage,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
