// 📄 lib/routes/grownups_route.dart
//
// createGrownUpsRoute — slide-up + fade transition into Grown Ups screen.

import 'package:flutter/material.dart';
import 'package:amagama/screens/grownups_screen.dart';

Route<dynamic> createGrownUpsRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const GrownUpsScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.15), // subtle slide up
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      final fadeAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      );

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}