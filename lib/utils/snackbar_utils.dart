// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: theme.snackBarTheme.contentTextStyle?.copyWith(
                height: 1.2,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark 
          ? theme.snackBarTheme.backgroundColor 
          : Colors.black.withOpacity(0.9),
      duration: duration,
      elevation: theme.snackBarTheme.elevation,
      width: 320,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
    ),
  );
}
