import 'package:flutter/material.dart';

Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: curvedAnimation.value,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        title,
        style: theme.dialogTheme.titleTextStyle,
      ),
      content: content,
      actions: actions,
      shape: theme.dialogTheme.shape,
      backgroundColor: theme.dialogTheme.backgroundColor,
      elevation: theme.dialogTheme.elevation,
    );
  }
}
