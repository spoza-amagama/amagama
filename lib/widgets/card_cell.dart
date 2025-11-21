// 📄 lib/widgets/card_cell.dart
//
// CardCell — single card used inside the match grid.
// • Handles flip animation
// • Shows sparkle burst when matched
// • Shows glow when selected
//

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/theme/index.dart';

class CardCell extends StatefulWidget {
  final CardItem item;
  final bool isMatched;
  final bool isGlowing;
  final Size size;
  final bool lockInput;
  final VoidCallback onFlip;

  const CardCell({
    super.key,
    required this.item,
    required this.isMatched,
    required this.isGlowing,
    required this.size,
    required this.lockInput,
    required this.onFlip,
  });

  @override
  State<CardCell> createState() => _CardCellState();
}

class _CardCellState extends State<CardCell>
    with SingleTickerProviderStateMixin {
  bool _showSparkles = false;

  @override
  void didUpdateWidget(CardCell old) {
    super.didUpdateWidget(old);

    if (!old.isMatched && widget.isMatched) {
      setState(() => _showSparkles = true);

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _showSparkles = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.item;
    final isFaceUp = card.isFaceUp;

    return GestureDetector(
      onTap: widget.lockInput ? null : widget.onFlip,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: widget.isMatched
                ? AmagamaColors.secondary.withValues(alpha: 0.65)
                : AmagamaColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isGlowing
                  ? AmagamaColors.primary
                  : Colors.transparent,
              width: widget.isGlowing ? 3 : 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // FRONT / BACK
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isFaceUp
                    ? Text(
                        card.word,
                        key: const ValueKey("front"),
                        style: AmagamaTypography.bodyStyle.copyWith(
                          fontSize: 20,
                          color: AmagamaColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : const Icon(Icons.help_outline_rounded,
                        key: ValueKey("back"), size: 26),
              ),

              if (_showSparkles) const SparkleLayer(),
            ],
          ),
        ),
      ),
    );
  }
}