// 📄 lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/index.dart';
import 'services/audio/audio_service.dart';
import 'routes/index.dart';
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
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => AudioControllerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amagama',
        theme: AmagamaTheme.light(),
        darkTheme: AmagamaTheme.dark(),
        initialRoute: AppRoutes.loading,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
