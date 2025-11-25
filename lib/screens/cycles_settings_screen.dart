// 📄 lib/screens/cycles_settings_screen.dart
//
// ♻️ Cycles Per Sentence — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/grownups/set_cycles_dialog.dart';

class CyclesSettingsScreen extends StatelessWidget {
  const CyclesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: "Cycles Per Sentence"),
            Expanded(child: SetCyclesDialog()),
          ],
        ),
      ),
    );
  }
}