import 'package:flutter/material.dart';

class ThemeAwareBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ThemeData theme) builder;
  final bool maintainState;

  const ThemeAwareBuilder({
    super.key,
    required this.builder,
    this.maintainState = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          if (maintainState) {
            return KeyedSubtree(
              key: ValueKey(theme.brightness),
              child: builder(context, theme),
            );
          }
          return builder(context, theme);
        },
      ),
    );
  }
}

class ThemeAwareRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  @override
  final bool maintainState;

  ThemeAwareRoute({
    required this.builder,
    this.maintainState = true,
  }) : super(fullscreenDialog: false);

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return ThemeAwareBuilder(
      maintainState: maintainState,
      builder: (context, theme) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: builder(context),
          ),
        );
      },
    );
  }
}

class ThemeAwareNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool _isTransitioning = false;

  static Future<T?> push<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool maintainState = true,
    bool fullscreenDialog = false,
    String? routeName,
  }) async {
    if (_isTransitioning) return null;
    _isTransitioning = true;

    try {
      return await Navigator.of(context).push(
        PageRouteBuilder<T>(
          settings: RouteSettings(name: routeName),
          pageBuilder: (context, animation, secondaryAnimation) {
            return RepaintBoundary(
              child: KeyedSubtree(
                key: ValueKey(Theme.of(context).brightness),
                child: builder(context),
              ),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        ),
      );
    } finally {
      _isTransitioning = false;
    }
  }

  static void pop<T>(BuildContext context, [T? result]) {
    if (!_isTransitioning && Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }
}

extension ThemeAwareContext on BuildContext {
  Future<T?> pushThemeAwarePage<T>({
    required WidgetBuilder builder,
    bool maintainState = true,
    bool fullscreenDialog = false,
    String? routeName,
  }) {
    return ThemeAwareNavigator.push(
      context: this,
      builder: builder,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      routeName: routeName,
    );
  }
}

class ThemeAwareContainer extends StatelessWidget {
  final Widget child;
  final bool maintainState;

  const ThemeAwareContainer({
    super.key,
    required this.child,
    this.maintainState = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!maintainState) {
      return child;
    }

    return RepaintBoundary(
      child: KeyedSubtree(
        key: ValueKey(Theme.of(context).brightness),
        child: child,
      ),
    );
  }
}