// 📄 lib/main.dart
//
// 🎮 Amagama — Entry Point
// ------------------------------------------------------------
// • Initializes game state, audio service, providers
// • Applies AmagamaTheme
// • Uses centralized routing via AppRoutes
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🧠 State + Controllers
import 'state/index.dart';
import 'controllers/card_grid_controller.dart';

// 🎵 Audio
import 'services/audio/audio_service.dart';

// 🌍 Routing barrel
import 'routes/index.dart';

// 🎨 Theme
import 'theme/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioService().preloadAll();

  runApp(const AmagamaApp());
}

class AmagamaApp extends StatelessWidget {
  const AmagamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()..init()),
        ChangeNotifierProvider(create: (_) => AudioControllerProvider()),
        ChangeNotifierProvider(create: (_) => CardGridController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amagama',
        theme: AmagamaTheme.light(),
        darkTheme: AmagamaTheme.dark(),

        // 🚦 Centralized routing
        initialRoute: AppRoutes.loading,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
