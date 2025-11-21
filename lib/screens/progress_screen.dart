// 📄 lib/screens/progress_screen.dart
// 📈 Amagama — Progress Screen

import 'package:flutter/material.dart';
import '../widgets/common/index.dart';
import '../widgets/progress/progress_list.dart';
import '../theme/index.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Progress',
              showLogo: false,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Expanded(child: ProgressList()),
          ],
        ),
      ),
    );
  }
}