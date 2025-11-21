// 📄 lib/widgets/app/amagama_app.dart
// AmagamaApp — root widget configuring providers, themes, and navigation.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/index.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/theme/index.dart';

class AmagamaApp extends StatelessWidget {
  const AmagamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => AudioControllerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amagama',
        theme: AmagamaTheme.light(),
        darkTheme: AmagamaTheme.dark(),
        // 🔑 Start the app on the animated splash screen
        initialRoute: AppRoutes.splash,
        // 🎬 All navigation goes through custom route builder
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}