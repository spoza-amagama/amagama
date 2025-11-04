import 'package:flutter/material.dart';

/// 🐘 HomeAppBar — minimalist responsive top bar.
/// ------------------------------------------------------------
/// • No logo or extra icons.
/// • Responsive font scaling.
/// • Transparent background for gradient integration.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 📏 Responsive scaling
    final isNarrow = width < 400;
    final fontSize = isNarrow ? 22.0 : 26.0;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Amagama',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
