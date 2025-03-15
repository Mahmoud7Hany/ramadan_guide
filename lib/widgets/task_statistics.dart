// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TaskStatistics extends StatelessWidget {
  final int completedValue;
  final int remainingValue;
  final int monthlyGoal;
  final int dailyRequired;
  final double progressPercentage;

  const TaskStatistics({
    super.key,
    required this.completedValue,
    required this.remainingValue,
    required this.monthlyGoal,
    required this.dailyRequired,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        LinearProgressIndicator(
          value: progressPercentage / 100,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard(
              context,
              title: 'تم إنجازه',
              value: completedValue,
              icon: Icons.check_circle_outline,
              color: theme.colorScheme.primary,
            ),
            _buildStatCard(
              context,
              title: 'متبقي',
              value: remainingValue,
              icon: Icons.pending_outlined,
              color: theme.colorScheme.error,
            ),
            _buildStatCard(
              context,
              title: 'المطلوب يومياً',
              value: dailyRequired,
              icon: Icons.calendar_today,
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        elevation: 0,
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                '$value',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}