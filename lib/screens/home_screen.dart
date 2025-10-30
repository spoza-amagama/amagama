import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_background.dart';
import '../widgets/home/home_content.dart';
import '../widgets/home/reset_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: HomeAppBar(onReset: () => _showResetDialog(context, game)),
      body: const HomeBackground(
        child: SafeArea(child: HomeContent()),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context, GameController game) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const ResetDialog(),
    );
    if (ok == true) {
      await game.resetAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game reset.')),
        );
      }
    }
  }
}
