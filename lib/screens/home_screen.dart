// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — simplified, week-free version
// ------------------------------------------------------------
// • Custom header with Amagama logo + title + logo
// • Body driven entirely by HomeContent
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/home/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _HomeLogoHeader(),
            Expanded(
              child: HomeContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeLogoHeader extends StatelessWidget {
  const _HomeLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/amagama_logo.png',
            height: 32,
          ),
          const SizedBox(width: 8),
          Text(
            'Amagama',
            style: AmagamaTypography.titleStyle.copyWith(
              fontSize: 28,
              color: AmagamaColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/logo/amagama_logo.png',
            height: 32,
          ),
        ],
      ),
    );
  }
}