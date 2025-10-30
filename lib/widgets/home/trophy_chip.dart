import 'package:flutter/material.dart';

class TrophyChip extends StatelessWidget {
  final String label;
  final bool earned;
  final Color color;

  const TrophyChip({
    super.key,
    required this.label,
    required this.earned,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(
        Icons.emoji_events_rounded,
        color: earned ? color : Colors.black26,
        size: 16,
      ),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: earned ? color.withValues(alpha: 0.15) : Colors.black12,
      shape: StadiumBorder(side: BorderSide(color: earned ? color : Colors.black26)),
    );
  }
}
