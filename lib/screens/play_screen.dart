// 📄 lib/screens/play_screen.dart
//
// ▶️ Play Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/play/play_content.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: "Play"),
            Expanded(child: PlayContent()),
          ],
        ),
      ),
    );
  }
}