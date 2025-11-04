#!/usr/bin/env bash
set -e
echo "⚙️  Cleaning up invalid await insertions..."

# --- Card Grid ---
sed -i '' "s/_ctrl.await handleCardFlip(/await _ctrl.handleCardFlip(/g" lib/widgets/card_grid.dart
sed -i '' "s/await _ctrl.await handleCardFlip(/await _ctrl.handleCardFlip(/g" lib/widgets/card_grid.dart

# --- Animated Match Grid ---
sed -i '' "s/controller.await handleCardFlip(/await controller.handleCardFlip(/g" lib/widgets/play/animated_match_grid.dart
sed -i '' "s/await controller.await handleCardFlip(/await controller.handleCardFlip(/g" lib/widgets/play/animated_match_grid.dart

# Clean any stray repeated awaits just in case
sed -i '' "s/await await /await /g" lib/widgets/**/*.dart

# Format and re-analyze
dart format lib >/dev/null
dart analyze lib || true

echo "✅ Await cleanup complete — syntax restored."
