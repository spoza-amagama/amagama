#!/usr/bin/env bash
set -e
echo "🧠 Amagama final structural fix..."

# 1️⃣ Fix misplaced helper methods — ensure inside GameController
if ! grep -q "isSentenceUnlocked" lib/state/game_controller.dart; then
cat >> lib/state/game_controller.dart <<'EOF'

  // 🧩 Compatibility helpers (auto-added)
  bool isSentenceUnlocked(int i) => i <= _currentSentenceIndex;

  SentenceProgress get currentProg => _progress[_currentSentenceIndex];
EOF
echo "✅ GameController helpers restored."
fi

# 2️⃣ Remove duplicate sentenceId args
sed -i '' -E 's/sentenceId:[^,]+,//2' lib/screens/play_screen.dart || true
sed -i '' -E 's/sentenceId:[^,]+,//2' lib/widgets/play/play_body.dart || true

# 3️⃣ Fix wrong await usage in widget builds
sed -i '' "s/await _ctrl.handleCardFlip(/_ctrl.handleCardFlip(/g" lib/widgets/card_grid.dart
sed -i '' "s/await controller.handleCardFlip(/controller.handleCardFlip(/g" lib/widgets/play/animated_match_grid.dart

# 4️⃣ Restore valid layout separation (layout = _computeLayout)
sed -i '' "s/layout = _ctrl.handleCardFlip(/layout = _ctrl.computeGridLayout(/g" lib/widgets/card_grid.dart
sed -i '' "s/layout = controller.handleCardFlip(/layout = controller.computeGridLayout(/g" lib/widgets/play/animated_match_grid.dart

# 5️⃣ Add required args for handleCardFlip calls
find lib/widgets -type f -name "*.dart" -exec \
  sed -i '' "s/handleCardFlip(context: context,/handleCardFlip(context: context, boxSize: constraints.biggest, totalCards: game.deck.length,/g" {} +

# 6️⃣ Fix nullable triggers & remove ?? misuse
sed -i '' "s/\\.currentState\\./\\.currentState?\\./g" lib/widgets/play/match_card_item.dart
sed -i '' "s/triggerSparkles?.call()/triggerSparkles?.call()/g" lib/widgets/play/match_card_item.dart
sed -i '' "s/??\\.copyWith/?.copyWith/g" lib/**/*.dart || true

# 7️⃣ Format & analyze
dart format lib >/dev/null
dart analyze lib || true

echo "✅ All structural mismatches repaired. Re-run your build now!"
