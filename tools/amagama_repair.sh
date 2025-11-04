#!/usr/bin/env bash
set -e

echo "🔧 Applying Amagama compatibility fixes (macOS version)..."

# 1️⃣ Null-safe callback invocations
sed -i '' "s/onWordFlip.call(/onWordFlip?.call(/g" lib/controllers/card_grid_controller.dart
sed -i '' "s/onSentenceComplete.call(/onSentenceComplete?.call(/g" lib/controllers/card_grid_controller.dart

# 2️⃣ Remove duplicate sentenceId args
sed -i '' "/sentenceId:/{
n; /sentenceId:/d
}" lib/screens/play_screen.dart || true
sed -i '' "/sentenceId:/{
n; /sentenceId:/d
}" lib/widgets/play/play_body.dart || true

# 3️⃣ Update old computeLayout calls → handleCardFlip args
find lib/widgets -type f -name "*.dart" -exec \
  sed -i '' "s/computeLayout(/handleCardFlip(context: context, /g" {} +

# 4️⃣ Add missing helpers to GameController if needed
grep -q "isSentenceUnlocked" lib/state/game_controller.dart || cat >> lib/state/game_controller.dart <<'EOF'

// 🧩 Compatibility helpers
bool isSentenceUnlocked(int i) => i <= currentSentenceIndex;
dynamic get currentProg => progress[currentSentenceIndex];
EOF

# 5️⃣ Clean nullable access & duplicates
sed -i '' "s/\.currentState\./\.currentState?\./g" lib/widgets/play/match_card_item.dart
sed -i '' "s/triggerSparkles()/triggerSparkles?.call()/g" lib/widgets/play/match_card_item.dart
sed -i '' "s/??\.copyWith/?.copyWith/g" lib/**/*.dart || true

# 6️⃣ Run analyzer & formatter
dart format lib >/dev/null
dart analyze lib || true

echo "✅ Amagama repair complete!"
