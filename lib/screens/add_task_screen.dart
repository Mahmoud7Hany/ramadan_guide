// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/animated_card.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _monthlyGoalController = TextEditingController();
  int _requiredDailyRate = 0;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _monthlyGoalController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _monthlyGoalController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final title = _titleController.text.trim();
    final monthlyGoal = int.tryParse(_monthlyGoalController.text) ?? 0;
    
    setState(() {
      _isFormValid = title.isNotEmpty && monthlyGoal > 0;
      if (_monthlyGoalController.text.isNotEmpty) {
        _requiredDailyRate = (monthlyGoal / 30).ceil();
      } else {
        _requiredDailyRate = 0;
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      final task = Task(
        id: DateTime.now().toString(),
        title: _titleController.text.trim(),
        monthlyGoal: int.parse(_monthlyGoalController.text),
        dailyGoal: _requiredDailyRate,
        startDate: DateTime.now(),
      );
      
      taskProvider.addTask(task);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text('تم إضافة المهمة بنجاح'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 300,
          duration: const Duration(seconds: 3),
        ),
      );

      _titleController.clear();
      _monthlyGoalController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedCard(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer.withOpacity(0.5),
                        theme.colorScheme.surface,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_task_rounded,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'إضافة مهمة جديدة',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'قم بإضافة مهمة جديدة لتتبع عباداتك في رمضان',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'اسم المهمة',
                  hintText: 'مثال: قراءة القرآن',
                  prefixIcon: const Icon(Icons.edit_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthlyGoalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الهدف الشهري',
                  hintText: 'مثال: 30',
                  prefixIcon: const Icon(Icons.flag_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الهدف الشهري';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'الرجاء إدخال رقم صحيح موجب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_requiredDailyRate > 0)
                AnimatedCard(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: theme.colorScheme.onSecondaryContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'المطلوب يومياً',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$_requiredDailyRate',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'مرة في اليوم',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: _isFormValid ? _submitForm : null,
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة المهمة'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  disabledBackgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
