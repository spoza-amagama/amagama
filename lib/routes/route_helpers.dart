// 📄 lib/routes/route_helpers.dart
// RouteHelpers — shared helpers for custom page transitions and guarded routes.

import 'package:flutter/material.dart';

enum RouteTransition {
  fade,
  slideRight,
  slideUp,
}

class RouteHelpers {
  const RouteHelpers._();

  static PageRouteBuilder<T> buildPageRoute<T>({
    required WidgetBuilder builder,
    required RouteSettings settings,
    RouteTransition transition = RouteTransition.slideRight,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transition) {
          case RouteTransition.fade:
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            return FadeTransition(
              opacity: curved,
              child: child,
            );

          case RouteTransition.slideUp:
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(curved);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );

          case RouteTransition.slideRight:
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
        }
      },
    );
  }
}