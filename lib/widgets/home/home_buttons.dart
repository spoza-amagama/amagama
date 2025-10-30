import 'package:flutter/material.dart';
import '../../screens/index.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _buildButton(context, 'Play', Icons.play_arrow_rounded, const PlayScreen()),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildButton(context, 'Progress', Icons.assessment_rounded, const ProgressScreen()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(context, 'Grown-Ups', Icons.settings_rounded, const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Widget screen) {
    return FilledButton.tonalIcon(
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)),
    );
  }
}
