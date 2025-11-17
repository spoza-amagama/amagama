// 📂 lib/widgets/play/play_app_bar.dart
import 'package:flutter/material.dart';

/// 🟨 PlayAppBar
/// Displays the current sentence number during gameplay.
class PlayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentSentenceIndex;

  const PlayAppBar({
    super.key,
    required this.currentSentenceIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Match the Words — Sentence ${currentSentenceIndex + 1}',
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: const Color(0xFFFFC107),
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}