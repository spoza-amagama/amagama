// 📄 lib/screens/grownups_screen.dart
// 👨‍👩‍👧 Grown Ups PIN Screen

import 'package:flutter/material.dart';
import '../widgets/common/screen_header.dart';
import '../widgets/home/grownup_pin_dialog.dart';
import '../theme/index.dart';

class GrownupsScreen extends StatelessWidget {
  const GrownupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Grown Ups',
              subtitle: 'Settings & Controls',
              showLogo: false,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Expanded(
              child: GrownUpPinDialog(isStandalone: true),
            ),
          ],
        ),
      ),
    );
  }
}