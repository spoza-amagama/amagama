// 📄 lib/screens/home_screen.dart
//
// 🏡 Home Screen — unified Amagama header + content
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
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
            AppPageHeader(title: "Home"),
            Expanded(child: HomeContent()),
          ],
        ),
      ),
    );
  }
}