// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — fixed layout (no vertical scrolling)

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
            ScreenHeader(
              title: 'Amagama',
              showLogo: true,
            ),

            // 👇 NO SCROLL, NO EXPANDED — let HomeContent control its height
            HomeContent(),
          ],
        ),
      ),
    );
  }
}