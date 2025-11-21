// 📄 lib/routes/app_routes.dart
//
// 🚦 Central Routing Table for Amagama
// ------------------------------------------------------------

import 'package:flutter/material.dart';

// Screens (single-use imports)
import 'package:amagama/screens/loading_screen.dart';
import 'package:amagama/screens/home_screen.dart';
import 'package:amagama/screens/play_screen.dart';
import 'package:amagama/screens/grownups_screen.dart';
import 'package:amagama/screens/progress_screen.dart'; // ✅ NEW

class AppRoutes {
  // 🔑 Route names
  static const String loading = '/loading';
  static const String home = '/home';
  static const String play = '/play';
  static const String grownups = '/grownups';
  static const String progress = '/progress'; // ✅ NEW

  // 🗺️ Static route table
  static final Map<String, WidgetBuilder> routes = {
    loading: (_) => const LoadingScreen(),
    home: (_) => const HomeScreen(),
    play: (_) => const PlayScreen(),
    grownups: (_) => const GrownupsScreen(),
    progress: (_) => const ProgressScreen(), // ✅ NEW
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
      case progress: // ✅ NEW
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}