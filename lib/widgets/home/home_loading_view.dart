// 📄 lib/widgets/home/home_loading_view.dart
//
// HomeLoadingView — simple loading state for the Home screen.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: AmagamaColors.warning,
      ),
    );
  }
}
