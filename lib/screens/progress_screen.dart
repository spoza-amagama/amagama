// 📄 lib/screens/progress_screen.dart
//
// 📊 Progress Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/progress/progress_list.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: "Progress"),
            Expanded(child: ProgressList()),
          ],
        ),
      ),
    );
  }
}