// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ThemeTransition extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const ThemeTransition({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  State<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends State<ThemeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(ThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isDark
                  ? [
                      Colors.black.withOpacity(_animation.value * 0.3),
                      Colors.black.withOpacity(_animation.value * 0.1),
                    ]
                  : [
                      Colors.white.withOpacity(_animation.value * 0.3),
                      Colors.white.withOpacity(_animation.value * 0.1),
                    ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}