#!/bin/bash
set -e
echo "🧩 Amagama Round 2 Fixes..."

# 1. Remove duplicate sentenceId args
sed -i.bak -E 's/(sentenceId:[^,]+,)[[:space:]]*sentenceId:[^,)]+,/\1/g' lib/screens/play_screen.dart lib/widgets/play/play_body.dart || true

# 2. Remove undefined 'game:' param from HomeHeader call
sed -i.bak -E 's/game:[^,]+,//g' lib/widgets/home/home_content.dart || true

# 3. Fix sparkleKey access
sed -i.bak -E 's/currentState!\.triggerSparkles/currentState?.triggerSparkles/g' lib/widgets/play/match_card_item.dart || true

# 4. Fix round_card.dart stray null-aware
sed -i.bak -E 's/\?\?\.//g' lib/widgets/round_card.dart || true
sed -i.bak -E 's/\?\?//g' lib/widgets/round_card.dart || true

# 5. Format everything
dart format lib >/dev/null || true

echo "✅ Fixes applied. Now run 'dart analyze'."
