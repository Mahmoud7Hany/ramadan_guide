// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/animated_card.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  String _formatDate(DateTime date) {
    final months = ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            task.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.secondary.withOpacity(0.05),
                theme.colorScheme.surface,
              ],
              stops: const [0.0, 0.3, 0.6],
            ),
          ),
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final updatedTask = taskProvider.tasks.firstWhere(
                (t) => t.id == task.id,
                orElse: () => task,
              );
              
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'task_${task.id}',
                      child: AnimatedCard(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                Color.lerp(theme.colorScheme.primary, theme.colorScheme.secondary, 0.5) ?? theme.colorScheme.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: -5,
                              ),
                              BoxShadow(
                                color: theme.colorScheme.secondary.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                                spreadRadius: -8,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 140,
                                    width: 140,
                                    child: CircularProgressIndicator(
                                      value: updatedTask.progress,
                                      strokeWidth: 12,
                                      backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${updatedTask.progressPercentage.toStringAsFixed(1)}%',
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'تم الإنجاز',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_rounded,
                                          color: theme.colorScheme.onPrimary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'بداية من ${updatedTask.startDate.toString().split(' ')[0]}',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_calendar_rounded,
                                            size: 18,
                                          ),
                                          color: theme.colorScheme.onPrimary,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                final controller = TextEditingController(
                                                  text: updatedTask.startDate.toString().split(' ')[0].replaceAll('-', '/'),
                                                );

                                                String getEndDate(DateTime startDate) {
                                                  return startDate.add(const Duration(days: 29))
                                                      .toString()
                                                      .split(' ')[0]
                                                      .replaceAll('-', '/');
                                                }

                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    String endDate = getEndDate(updatedTask.startDate);

                                                    return AlertDialog(
                                                      title: const Text('تعديل تاريخ البداية'),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            controller: controller,
                                                            textDirection: TextDirection.ltr,
                                                            textAlign: TextAlign.center,
                                                            decoration: InputDecoration(
                                                              hintText: 'YYYY/MM/DD',
                                                              hintTextDirection: TextDirection.ltr,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              contentPadding: const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 16,
                                                              ),
                                                            ),
                                                            onChanged: (value) {
                                                              if (value.length == 4 || value.length == 7) {
                                                                controller.text = '$value/';
                                                                controller.selection = TextSelection.fromPosition(
                                                                  TextPosition(offset: value.length + 1),
                                                                );

                                                                try {
                                                                  final parts = value.split('/');
                                                                  if (parts.length == 3) {
                                                                    final newStartDate = DateTime(
                                                                      int.parse(parts[0]),
                                                                      int.parse(parts[1]),
                                                                      int.parse(parts[2]),
                                                                    );
                                                                    setState(() {
                                                                      endDate = getEndDate(newStartDate);
                                                                    });
                                                                  }
                                                                } catch (_) {}
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'الرجاء إدخال التاريخ';
                                                              }

                                                              try {
                                                                final parts = value.split('/');
                                                                if (parts.length != 3) return 'صيغة تاريخ غير صحيحة';

                                                                final year = int.parse(parts[0]);
                                                                final month = int.parse(parts[1]);
                                                                final day = int.parse(parts[2]);

                                                                if (month < 1 || month > 12) return 'الشهر يجب أن يكون بين 1 و 12';
                                                                if (day < 1 || day > 31) return 'اليوم يجب أن يكون بين 1 و 31';

                                                                final date = DateTime(year, month, day);
                                                                if (date.month != month) return 'تاريخ غير صحيح';
                                                                
                                                                return null;
                                                              } catch (e) {
                                                                return 'تاريخ غير صحيح';
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Text(
                                                            'تاريخ الانتهاء: $endDate',
                                                            style: theme.textTheme.titleSmall,
                                                            textDirection: TextDirection.ltr,
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Text(
                                                            'مثال: ${DateTime.now().toString().split(' ')[0].replaceAll('-', '/')}',
                                                            style: theme.textTheme.bodySmall?.copyWith(
                                                              color: theme.colorScheme.onSurfaceVariant,
                                                            ),
                                                            textDirection: TextDirection.ltr,
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('إلغاء'),
                                                        ),
                                                        FilledButton(
                                                          onPressed: () {
                                                            if (controller.text.isNotEmpty) {
                                                              try {
                                                                final parts = controller.text.split('/');
                                                                final newDate = DateTime(
                                                                  int.parse(parts[0]),
                                                                  int.parse(parts[1]),
                                                                  int.parse(parts[2]),
                                                                );
                                                                
                                                                final newTask = Task(
                                                                  id: updatedTask.id,
                                                                  title: updatedTask.title,
                                                                  monthlyGoal: updatedTask.monthlyGoal,
                                                                  dailyGoal: updatedTask.dailyGoal,
                                                                  startDate: newDate,
                                                                  completedDays: updatedTask.completedDays,
                                                                );
                                                                taskProvider.updateTask(updatedTask.id, newTask);
                                                                Navigator.pop(context);
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                    content: const Text('تاريخ غير صحيح'),
                                                                    backgroundColor: theme.colorScheme.error,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: const Text('حفظ'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.white24,
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_rounded,
                                          color: theme.colorScheme.onPrimary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'تنتهي في ${updatedTask.startDate.add(const Duration(days: 29)).toString().split(' ')[0]}',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedCard(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.secondary.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${updatedTask.requiredDailyRate}',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: theme.colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'المطلوب يومياً',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AnimatedCard(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${updatedTask.remainingDays}',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: theme.brightness == Brightness.light
                                          ? Colors.black87
                                          : Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'الأيام المتبقية',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.brightness == Brightness.light
                                          ? Colors.black87
                                          : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تتبع الأيام',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              final day = index + 1;
                              final date = updatedTask.startDate
                                  .add(Duration(days: index))
                                  .toIso8601String()
                                  .split('T')[0];
                              final isCompleted = updatedTask.completedDays[date] ?? false;
                              final isToday = DateTime.now()
                                      .difference(updatedTask.startDate)
                                      .inDays ==
                                  index;

                              return AnimatedScale(
                                scale: isCompleted || isToday ? 1.0 : 0.95,
                                duration: const Duration(milliseconds: 200),
                                child: Hero(
                                  tag: 'day_$day',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        final newTask = updatedTask.toggleDay(date);
                                        taskProvider.updateTask(updatedTask.id, newTask);
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOutCubic,
                                        decoration: BoxDecoration(
                                          gradient: isCompleted
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xFF4C73FF), // لون أزرق فاتح
                                                    Color(0xFF2B5DFF), // لون أزرق غامق
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                              : null,
                                          color: isToday
                                              ? Color.lerp(
                                                  const Color(0xFF4C73FF),
                                                  theme.colorScheme.surface,
                                                  0.85)
                                              : theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isCompleted
                                                ? Colors.transparent
                                                : isToday
                                                    ? const Color(0xFF4C73FF)
                                                    : theme.colorScheme.outline
                                                        .withOpacity(0.2),
                                            width: isToday ? 2 : 1,
                                          ),
                                          boxShadow: isCompleted
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(0xFF4C73FF).withOpacity(0.3),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                    spreadRadius: -2,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Text(
                                              '$day',
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                color: isCompleted
                                                    ? Colors.white
                                                    : isToday
                                                        ? const Color(0xFF4C73FF)
                                                        : theme.colorScheme.onSurface,
                                                fontWeight: isCompleted || isToday
                                                    ? FontWeight.bold
                                                    : null,
                                                fontSize: 20,
                                              ),
                                            ),
                                            if (isCompleted)
                                              AnimatedPositioned(
                                                duration: const Duration(milliseconds: 200),
                                                right: 6,
                                                top: 6,
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.3),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
