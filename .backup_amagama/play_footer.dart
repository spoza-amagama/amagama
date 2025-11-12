// 📄 lib/widgets/play/play_footer.dart
//
// Footer displaying progress message and audio state,
// themed with AmagamaTypography and AmagamaColors.

import 'package:flutter/material.dart';
import '../../../state/game_controller.dart';
import '../../../services/audio/audio_service.dart';
import '../../../widgets/play/audio_state_bridge.dart';
import '../../../theme/index.dart';

class PlayFooter extends StatelessWidget {
  final GameController controller;
  final AudioService audio;

  const PlayFooter({
    super.key,
    required this.controller,
    required this.audio,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AmagamaTypography.textTheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AmagamaSpacing.lg,
        top: AmagamaSpacing.sm,
      ),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: controller.progress,
            builder: (context, progress, _) => Text(
              progress.message,
              style: textTheme.bodyLarge?.copyWith(
                color: AmagamaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AmagamaSpacing.sm),
          AudioStateBridge(audio: audio),
        ],
      ),
    );
  }
}
