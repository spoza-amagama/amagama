// lib/widgets/sentence_header.dart
import 'package:flutter/material.dart';
import 'animated_sentence_text.dart';
import 'sparkle_layer.dart';

/// Combines animated sentence text and sparkles into one header component.
class SentenceHeader extends StatefulWidget {
  final String text;
  final AnimationController controller;

  const SentenceHeader({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  State<SentenceHeader> createState() => _SentenceHeaderState();
}

class _SentenceHeaderState extends State<SentenceHeader> {
  final GlobalKey<SparkleLayerState> _sparkleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _sparkleKey.currentState?.triggerSparkles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SparkleLayer(key: _sparkleKey),
            AnimatedSentenceText(
              text: widget.text,
              controller: widget.controller,
            ),
          ],
        ),
      ),
    );
  }
}