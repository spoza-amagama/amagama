// 📄 lib/widgets/common/amagama_scaffold.dart
//
// Standard layout for all screens with a FIXED header.
// Content scrolls underneath.

import 'package:flutter/material.dart';
import 'amagama_header.dart';
import 'package:amagama/theme/index.dart';

class AmagamaScaffold extends StatelessWidget {
  final String subtitle;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  const AmagamaScaffold({
    super.key,
    required this.subtitle,
    required this.child,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AmagamaHeader(
              subtitle: subtitle,
              leading: leading,
              trailing: trailing,
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
