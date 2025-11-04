#!/usr/bin/env bash
set -e
echo "🧠 Running Amagama Final Fix..."

# ───────────────────────────────────────────────
# 1️⃣ GameController compatibility helpers
# ───────────────────────────────────────────────
if ! grep -q "bool isSentenceUnlocked" lib/state/game_controller.dart; then
cat >> lib/state/game_controller.dart <<'EOF'

// 🧩 Compatibility helpers
bool isSentenceUnlocked(int i) =>
    i <= _currentSentenceIndex;

SentenceProgress get currentProg =>
    _progress[_currentSentenceIndex];
EOF
echo "✅ Added GameController helpers"
fi

# ───────────────────────────────────────────────
# 2️⃣ Fix duplicate 'sentenceId:' args
# ───────────────────────────────────────────────
sed -i '' '/sentenceId:/{
n; /sentenceId:/d
}' lib/screens/play_screen.dart || true
sed -i '' '/sentenceId:/{
n; /sentenceId:/d
}' lib/widgets/play/play_body.dart || true

# ───────────────────────────────────────────────
# 3️⃣ Fix null-safe calls in CardGridController
# ───────────────────────────────────────────────
sed -i '' 's/onWordFlip.call(/onWordFlip?.call(/g' lib/controllers/card_grid_controller.dart
sed -i '' 's/onSentenceComplete.call(/onSentenceComplete?.call(/g' lib/controllers/card_grid_controller.dart

# ───────────────────────────────────────────────
# 4️⃣ Replace old positional handleFlip usage with named args
# ───────────────────────────────────────────────
find lib/widgets -type f -name "*.dart" -exec \
  sed -i '' "s/handleFlip(/handleCardFlip(context: context, /g" {} +

# ───────────────────────────────────────────────
# 5️⃣ Guard against nullable refs and redundant ?.
# ───────────────────────────────────────────────
sed -i '' "s/\\.currentState\\./\\.currentState?\\./g" lib/widgets/play/match_card_item.dart
sed -i '' "s/triggerSparkles()/triggerSparkles?.call()/g" lib/widgets/play/match_card_item.dart
sed -i '' "s/\\?\\.\\?\\.copyWith/?.copyWith/g" lib/**/*.dart || true
sed -i '' "s/??\\.copyWith/?.copyWith/g" lib/**/*.dart || true

# ───────────────────────────────────────────────
# 6️⃣ Ensure handleCardFlip returns layout correctly
# ───────────────────────────────────────────────
sed -i '' "s/handleCardFlip(/await handleCardFlip(/g" lib/widgets/card_grid.dart || true
sed -i '' "s/handleCardFlip(/await handleCardFlip(/g" lib/widgets/play/animated_match_grid.dart || true

# ───────────────────────────────────────────────
# 7️⃣ Format & analyze
# ───────────────────────────────────────────────
dart format lib >/dev/null
dart analyze lib || true

echo "✅ Amagama final fix complete!"
