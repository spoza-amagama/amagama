// 📄 lib/routes/app_routes.dart
// 🚦 Central Routing Table for Amagama

import 'package:flutter/material.dart';

import 'package:amagama/screens/loading_screen.dart';
import 'package:amagama/screens/home_screen.dart';
import 'package:amagama/screens/play_screen.dart';
import 'package:amagama/screens/grownups_screen.dart';
import 'package:amagama/screens/progress_screen.dart';
import 'package:amagama/screens/cycles_settings_screen.dart';

// Splash
import 'package:amagama/widgets/splash/index.dart' as splashw;

// Route helpers (animations)
import 'package:amagama/routes/route_helpers.dart';

class AppRoutes {
  // 🔑 Route names
  static const String splash = '/splash';
  static const String loading = '/loading';
  static const String home = '/home';
  static const String play = '/play';
  static const String grownups = '/grownups';
  static const String progress = '/progress';
  static const String cyclesSettings = '/cycles-settings';

  // 🧭 Upgraded dynamic routing
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? home);
    final path = uri.path;

    switch (path) {
      case splash:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const splashw.AnimatedSplashScreen(),
          settings: settings,
          transition: RouteTransition.fade,
        );

      case loading:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const LoadingScreen(),
          settings: settings,
          transition: RouteTransition.fade,
        );

      case home:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
          transition: RouteTransition.fade,
        );

      case play:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const PlayScreen(),
          settings: settings,
          transition: RouteTransition.slideRight,
        );

      case grownups:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const GrownUpsScreen(),
          settings: settings,
          transition: RouteTransition.slideUp,
          fullscreenDialog: true,
        );

      case progress:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const ProgressScreen(),
          settings: settings,
          transition: RouteTransition.slideRight,
        );

      case cyclesSettings:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const CyclesSettingsScreen(),
          settings: settings,
          transition: RouteTransition.slideRight,
        );

      default:
        return RouteHelpers.buildPageRoute(
          builder: (_) => const HomeScreen(),
          settings: const RouteSettings(name: home),
          transition: RouteTransition.fade,
        );
    }
  }
}