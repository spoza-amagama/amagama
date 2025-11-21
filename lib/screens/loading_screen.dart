// 📄 lib/screens/loading_screen.dart
// LoadingScreen — performs async startup tasks then navigates to Home.

import 'package:flutter/material.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/services/audio/audio_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Preload audio or any other startup services
    await AudioService().preloadAll();

    if (!mounted) return;

    // Navigate to home when ready
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
