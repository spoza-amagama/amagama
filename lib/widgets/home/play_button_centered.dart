// 📄 lib/widgets/home/play_button_centered.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/routes/index.dart';

class PlayButtonCentered extends StatelessWidget {
  const PlayButtonCentered({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AmagamaColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, AppRoutes.play),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Play",
            style: AmagamaTypography.buttonStyle.copyWith(
              color: Colors.white,
            ),
          ),
          const Positioned(
            left: 20,
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
        ],
      ),
    );
  }
}