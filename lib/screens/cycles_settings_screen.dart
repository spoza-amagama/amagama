// 📄 lib/screens/cycles_settings_screen.dart
//
// CyclesSettingsScreen — standalone fine-tuned screen.
// ------------------------------------------------------------
// • Uses global AmagamaHeader (logo + title + subtitle)
// • Clean description + slider UI
// • Matches spacing, background, and typography system
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/cycle_service.dart';
import 'package:amagama/widgets/common/amagama_header.dart';

class CyclesSettingsScreen extends StatelessWidget {
  const CyclesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final int current = game.cycles.cyclesTarget;

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ------------------------------------------------------------
            // 🔵 GLOBAL HEADER
            // ------------------------------------------------------------
            const AmagamaHeader(subtitle: 'Cycles'),

            const SizedBox(height: AmagamaSpacing.sm),

            // ------------------------------------------------------------
            // MAIN CONTENT
            // ------------------------------------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AmagamaSpacing.md,
                  vertical: AmagamaSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --------------------------------------------------------
                    // SUBTITLE
                    // --------------------------------------------------------
                    Text(
                      'How many repeats unlock the next one?',
                      style: AmagamaTypography.bodyStyle.copyWith(
                        color: AmagamaColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --------------------------------------------------------
                    // SECTION HEADING
                    // --------------------------------------------------------
                    Text(
                      'Cycles per sentence',
                      style: AmagamaTypography.titleStyle.copyWith(
                        color: AmagamaColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Each sentence must be completed this many times\n'
                      'before the next one unlocks.',
                      style: AmagamaTypography.bodyStyle.copyWith(
                        color: AmagamaColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --------------------------------------------------------
                    // SLIDER
                    // --------------------------------------------------------
                    Row(
                      children: [
                        const Text(
                          '${CycleService.minCycles}',
                          style: AmagamaTypography.bodyStyle,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              activeTrackColor: AmagamaColors.primary,
                              inactiveTrackColor: AmagamaColors.textSecondary
                                  .withValues(alpha: 0.3),
                              thumbColor: AmagamaColors.primary,
                            ),
                            child: Slider(
                              min: CycleService.minCycles.toDouble(),
                              max: CycleService.maxCycles.toDouble(),
                              value: current.toDouble(),
                              divisions: CycleService.maxCycles -
                                  CycleService.minCycles,
                              label: '$current',
                              onChanged: (value) {
                                context
                                    .read<GameController>()
                                    .updateCyclesTarget(value.round());
                              },
                            ),
                          ),
                        ),
                        const Text(
                          '${CycleService.maxCycles}',
                          style: AmagamaTypography.bodyStyle,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Current: $current cycles',
                        style: AmagamaTypography.bodyStyle.copyWith(
                          color: AmagamaColors.textPrimary,
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}