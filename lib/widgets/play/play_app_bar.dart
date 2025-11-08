// 📄 lib/widgets/play/play_app_bar.dart
// 🧭 PlayAppBar — minimal, shows no sentence text
// ----------------------------------------------------------
// Ensures the app bar never renders the current sentence or cycle text.

import 'package:flutter/material.dart';

class PlayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlayAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Play'), // ✅ keep generic; no sentence here
      centerTitle: true,
      elevation: 0,
    );
  }
}
