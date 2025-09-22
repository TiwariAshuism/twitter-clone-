
import 'package:chirper/core/navigation/page_trasition.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Default animation settings
  static AnimationType defaultAnimation = AnimationType.slideFromRight;
  static Duration defaultDuration = const Duration(milliseconds: 300);
  static Curve defaultCurve = Curves.easeInOut;

  /// Create custom page route with animation
  static PageRouteBuilder<T> _createAnimatedRoute<T>(
    Widget page, {
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
    RouteSettings? settings,
  }) {
    final animation = animationType ?? defaultAnimation;
    final animationDuration = duration ?? defaultDuration;
    final animationCurve = curve ?? defaultCurve;

    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, primaryAnimation, secondaryAnimation) => page,
      transitionDuration: animationDuration,
      reverseTransitionDuration: animationDuration,
      transitionsBuilder: (context, primaryAnimation, secondaryAnimation, child) {
        return _buildTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          animationType: animation,
          curve: animationCurve,
        );
      },
    );
  }

  /// Build transition based on animation type
  static Widget _buildTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required AnimationType animationType,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (animationType) {
      case AnimationType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case AnimationType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case AnimationType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case AnimationType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case AnimationType.fadeIn:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case AnimationType.scaleIn:
        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );

      case AnimationType.rotateIn:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case AnimationType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
    }
  }

  /// Safe push with animation
  static Future<T?> pushNamed<T extends Object?>(
    String route, {
    Object? args,
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      return await navigatorKey.currentState?.pushNamed<T>(
        route,
        arguments: args,
      );
    } catch (e, stack) {
      debugPrint("Navigation Error (pushNamed): $e\n$stack");
      return null;
    }
  }

  /// Push widget directly with animation
  static Future<T?> pushWidget<T extends Object?>(
    Widget page, {
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      final route = _createAnimatedRoute<T>(
        page,
        animationType: animationType,
        duration: duration,
        curve: curve,
      );
      return await navigatorKey.currentState?.push<T>(route);
    } catch (e, stack) {
      debugPrint("Navigation Error (pushWidget): $e\n$stack");
      return null;
    }
  }

  /// Safe push replacement with animation
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String route, {
    Object? args,
    TO? result,
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      return await navigatorKey.currentState?.pushReplacementNamed<T, TO>(
        route,
        arguments: args,
        result: result,
      );
    } catch (e, stack) {
      debugPrint("Navigation Error (pushReplacementNamed): $e\n$stack");
      return null;
    }
  }

  /// Push replacement widget directly with animation
  static Future<T?> pushReplacementWidget<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      final route = _createAnimatedRoute<T>(
        page,
        animationType: animationType,
        duration: duration,
        curve: curve,
      );
      return await navigatorKey.currentState?.pushReplacement<T, TO>(
        route,
        result: result,
      );
    } catch (e, stack) {
      debugPrint("Navigation Error (pushReplacementWidget): $e\n$stack");
      return null;
    }
  }

  /// Push and clear stack with animation
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String route, {
    Object? args,
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      return await navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
        route,
        (route) => false,
        arguments: args,
      );
    } catch (e, stack) {
      debugPrint("Navigation Error (pushNamedAndRemoveUntil): $e\n$stack");
      return null;
    }
  }

  /// Push widget and clear stack with animation
  static Future<T?> pushWidgetAndRemoveUntil<T extends Object?>(
    Widget page, {
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) async {
    try {
      final route = _createAnimatedRoute<T>(
        page,
        animationType: animationType,
        duration: duration,
        curve: curve,
      );
      return await navigatorKey.currentState?.pushAndRemoveUntil<T>(
        route,
        (route) => false,
      );
    } catch (e, stack) {
      debugPrint("Navigation Error (pushWidgetAndRemoveUntil): $e\n$stack");
      return null;
    }
  }

  /// Pop with custom animation
  static void pop<T extends Object?>([T? result]) {
    try {
      navigatorKey.currentState?.pop<T>(result);
    } catch (e, stack) {
      debugPrint("Navigation Error (pop): $e\n$stack");
    }
  }

  /// Pop until route
  static void popUntil(String routeName) {
    try {
      navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
    } catch (e, stack) {
      debugPrint("Navigation Error (popUntil): $e\n$stack");
    }
  }

  /// Check if can pop
  static bool canPop() {
    try {
      return navigatorKey.currentState?.canPop() ?? false;
    } catch (e, stack) {
      debugPrint("Navigation Error (canPop): $e\n$stack");
      return false;
    }
  }

  /// Show animated snackbar
  static void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    AnimationType snackBarAnimation = AnimationType.slideFromBottom,
  }) {
    try {
      final context = navigatorKey.currentContext;
      if (context == null) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 6,
        ),
      );
    } catch (e, stack) {
      debugPrint("SnackBar Error: $e\n$stack");
    }
  }

  /// Show success message
  static void showSuccess(String message) {
    showSnackBar(message, isError: false);
  }

  /// Show error message
  static void showError(String message) {
    showSnackBar(message, isError: true);
  }

  /// Set default animation settings
  static void setDefaultAnimation({
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) {
    if (animationType != null) defaultAnimation = animationType;
    if (duration != null) defaultDuration = duration;
    if (curve != null) defaultCurve = curve;
  }

  /// Show animated dialog
  static Future<T?> showAnimatedDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    AnimationType animationType = AnimationType.scaleIn,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    try {
      final context = navigatorKey.currentContext;
      if (context == null) return null;

      return await showGeneralDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: duration,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
            animationType: animationType,
            curve: curve,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) => dialog,
      );
    } catch (e, stack) {
      debugPrint("Dialog Error: $e\n$stack");
      return null;
    }
  }
}

// Extension for easy access to navigation methods
extension NavigationExtension on Widget {
  Future<T?> pushTo<T>({
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) {
    return NavigationService.pushWidget<T>(
      this,
      animationType: animationType,
      duration: duration,
      curve: curve,
    );
  }

  Future<T?> pushReplacementTo<T, TO>({
    TO? result,
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) {
    return NavigationService.pushReplacementWidget<T, TO>(
      this,
      result: result,
      animationType: animationType,
      duration: duration,
      curve: curve,
    );
  }

  Future<T?> pushAndClearStack<T>({
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
  }) {
    return NavigationService.pushWidgetAndRemoveUntil<T>(
      this,
      animationType: animationType,
      duration: duration,
      curve: curve,
    );
  }
}