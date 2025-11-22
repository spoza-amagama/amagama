// 📄 lib/widgets/home/home_header_trophies_section.dart
//
// HomeHeaderTrophiesSection — spacing wrapper around HomeTrophies.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import '../home_trophies.dart';

class HomeHeaderTrophiesSection extends StatelessWidget {
  const HomeHeaderTrophiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AmagamaSpacing.sm),
      child: HomeTrophies(),
    );
  }
}
