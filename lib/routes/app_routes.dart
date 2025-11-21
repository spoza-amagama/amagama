// 📄 lib/routes/app_routes.dart
// 🚦 Central Routing Table for Amagama (upgraded with transitions & guards)
// ------------------------------------------------------------

import 'package:flutter/material.dart';

// Screens
import 'package:amagama/screens/loading_screen.dart';
import 'package:amagama/screens/home_screen.dart';
import 'package:amagama/screens/play_screen.dart';
import 'package:amagama/screens/grownups_screen.dart';
import 'package:amagama/screens/progress_screen.dart';

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

  // 🧭 Upgraded dynamic routing (deep-linking + transitions)
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Deep-link friendly
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
        // 🔒 Guarded: can hook PIN or auth here later
        return RouteHelpers.buildPageRoute(
          builder: (_) => const GrownupsScreen(),
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

      default:
        // 🌐 Unknown deep link → Home (fade)
        return RouteHelpers.buildPageRoute(
          builder: (_) => const HomeScreen(),
          settings: const RouteSettings(name: home),
          transition: RouteTransition.fade,
        );
    }
  }
}