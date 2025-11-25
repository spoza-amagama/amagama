// 📄 lib/screens/loading_screen.dart
//
// ⏳ Loading Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: "Loading"),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AmagamaColors.primary,
                  strokeWidth: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}