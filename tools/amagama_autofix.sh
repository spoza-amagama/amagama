#!/bin/bash
set -e

echo "🧹 Running Amagama automated cleanup fixes..."

# --- 1. Remove duplicate sentenceId arguments
echo "🩹 Removing duplicate 'sentenceId' arguments..."
grep -rl "sentenceId:" lib/screens/play_screen.dart lib/widgets/play/play_body.dart | while read -r file; do
  sed -i.bak -E 's/(sentenceId:[^,]+,)[[:space:]]*sentenceId:[^,)]+,/\1/g' "$file" || true
done

# --- 2. Remove unused locals in card_flip_controller.dart
echo "🩹 Cleaning unused locals in card_flip_controller.dart..."
sed -i.bak -E '/final bool isMatched|final bool isGlowing/d' lib/widgets/card_flip_controller.dart || true

# --- 3. Add const where missing
echo "🩹 Enforcing const constructors..."
sed -i.bak -E 's/([^A-Za-z0-9_])HomeButtons\(\)/\1const HomeButtons()/g' lib/widgets/home/home_content.dart || true

# --- 4. Fix animated_match_grid.dart (remove invalid context param)
echo "🩹 Fixing invalid parameter in animated_match_grid.dart..."
sed -i.bak -E 's/context:[^,]+,//g' lib/widgets/play/animated_match_grid.dart || true

# --- 5. Safe access for currentState in match_card_item.dart
echo "🩹 Fixing nullable currentState access..."
sed -i.bak -E 's/\.currentState!/.currentState?/g' lib/widgets/play/match_card_item.dart || true
sed -i.bak -E 's/\.currentState\?\.triggerSparkles\(\)/?.currentState?.triggerSparkles()/g' lib/widgets/play/match_card_item.dart || true

# --- 6. Remove redundant null-aware left operand in round_card.dart
echo "🩹 Removing dead null-aware expressions..."
sed -i.bak -E 's/\?\?\.//g' lib/widgets/round_card.dart || true
sed -i.bak -E 's/\?\?//g' lib/widgets/round_card.dart || true

# --- 7. Run formatter
echo "🧩 Formatting..."
dart format lib >/dev/null || true

echo "✅ Cleanup complete! Re-run 'dart analyze' to confirm."
