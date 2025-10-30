import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onReset;
  const HomeAppBar({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Amagama'),
      backgroundColor: const Color(0xFFFFC107),
      actions: [
        IconButton(
          tooltip: 'Reset Game',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
