// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ThemeSwitchBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const ThemeSwitchBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        tween: Tween<double>(
          begin: 0,
          end: isDark ? 1.0 : 0.0,
        ),
        builder: (context, value, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isDark ? Colors.black.withOpacity(value) : Colors.transparent,
                  isDark ? Colors.black.withOpacity(value * 0.8) : Colors.transparent,
                ],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}