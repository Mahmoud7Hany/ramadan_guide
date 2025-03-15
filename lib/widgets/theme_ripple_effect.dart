import 'package:flutter/material.dart';

class ThemeRippleEffect extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final Offset? origin;

  const ThemeRippleEffect({
    super.key,
    required this.child,
    required this.isDark,
    this.origin,
  });

  @override
  State<ThemeRippleEffect> createState() => _ThemeRippleEffectState();
}

class _ThemeRippleEffectState extends State<ThemeRippleEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _rippleOrigin;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void didUpdateWidget(ThemeRippleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      _rippleOrigin = widget.origin ?? Offset.zero;
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
        return ClipPath(
          clipper: CircularRevealClipper(
            origin: _rippleOrigin ?? Offset.zero,
            fraction: _animation.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final Offset origin;
  final double fraction;

  CircularRevealClipper({
    required this.origin,
    required this.fraction,
  });

  @override
  Path getClip(Size size) {
    final radius = _calcMaxRadius(size, origin);
    
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: origin,
          radius: radius * fraction,
        ),
      );
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return origin != oldClipper.origin || fraction != oldClipper.fraction;
  }

  double _calcMaxRadius(Size size, Offset origin) {
    final w = size.width;
    final h = size.height;
    final points = [
      Offset.zero,
      Offset(w, 0),
      Offset(0, h),
      Offset(w, h),
    ];
    double maxRadius = 0;

    for (var point in points) {
      final radius = (point - origin).distance;
      if (radius > maxRadius) {
        maxRadius = radius;
      }
    }

    return maxRadius;
  }
}