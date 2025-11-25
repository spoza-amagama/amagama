// 📄 lib/screens/grownups_screen.dart
//
// 👨‍👩‍👧 GrownUpsScreen — parental settings with bottom-left back button.
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/grownups/grownups_content.dart';

class GrownUpsScreen extends StatelessWidget {
  const GrownUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ----------------------------
            // MAIN CONTENT
            // ----------------------------
            Column(
              children: const [
                AppPageHeader(title: "Grown Ups"),
                Expanded(child: GrownupsContent()),
              ],
            ),

            // ----------------------------
            // BOTTOM-LEFT BACK BUTTON
            // ----------------------------
            Positioned(
              bottom: 20,
              left: 20,
              child: _BackButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded,
                  size: 22, color: AmagamaColors.textPrimary),
              SizedBox(width: 6),
              Text(
                "Back",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AmagamaColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}