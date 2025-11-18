// 📄 lib/routes/app_routes.dart
//
// 🚦 Central Routing Table for Amagama
// ------------------------------------------------------------
// • Defines route names
// • Provides routes map for MaterialApp
// • Provides onGenerateRoute fallback
// ------------------------------------------------------------

import 'package:flutter/material.dart';

// Screens (single-use imports)
import 'package:amagama/screens/loading_screen.dart';
import 'package:amagama/screens/home_screen.dart';
import 'package:amagama/screens/play_screen.dart';
import 'package:amagama/screens/grownups_screen.dart';

class AppRoutes {
  // 🔑 Route names
  static const String loading = '/loading';
  static const String home = '/home';
  static const String play = '/play';
  static const String grownups = '/grownups';

  // 🗺️ Static route table
  static final Map<String, WidgetBuilder> routes = {
    loading: (_) => const LoadingScreen(),
    home: (_) => const HomeScreen(),
    play: (_) => const PlayScreen(),
    grownups: (_) => const GrownupsScreen(),
  };

  // 🧭 Fallback / dynamic routing
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case play:
        return MaterialPageRoute(builder: (_) => const PlayScreen());
      case grownups:
        return MaterialPageRoute(builder: (_) => const GrownupsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
