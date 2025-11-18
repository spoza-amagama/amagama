// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — fixed vertical layout, safe + no overflow
// ------------------------------------------------------------
// • Shows App header
// • Wraps HomeContent in Expanded to prevent vertical overflow
// • No scrolling on this screen (HomeContent manages its own)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/screen_header.dart';
import 'package:amagama/widgets/home/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: const [
            // App title + logo
            ScreenHeader(
              title: 'Amagama',
              showLogo: true,
            ),

            // Ensures HomeContent fills remaining space
            Expanded(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: HomeContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}