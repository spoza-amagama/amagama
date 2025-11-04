#!/bin/bash
# 🩹 amagama_fix_refs.sh
# ------------------------------------------------------------
# Fixes all controller + widget callsite mismatches introduced
# by the CardGridController functional refactor.
# Run from your Amagama project root.

echo "🔧 Applying Amagama controller + widget fixes..."

# 1️⃣ Update API names across project
echo "→ Updating method names..."
find lib -type f -name "*.dart" -print0 | xargs -0 sed -i '' \
  -e 's/computeGridLayout/computeLayout/g' \
  -e 's/handleFlip/handleCardFlip/g'

# 2️⃣ Remove deprecated onCardTap named parameter
echo "→ Removing old onCardTap argument..."
find lib -type f -name "*.dart" -print0 | xargs -0 sed -i '' \
  -e 's/onCardTap:[^,)]*[,)]//g'

# 3️⃣ Inject sentenceId where missing (PlayScreen + PlayBody)
echo "→ Ensuring sentenceId argument present in AnimatedMatchGrid..."
find lib/screens -type f -name "play_screen.dart" -print0 | xargs -0 sed -i '' \
  -e 's/AnimatedMatchGrid([^)]*cards: *\([^,)]*\))/AnimatedMatchGrid(cards: \1, sentenceId: game.currentSentenceIndex)/g'
find lib/widgets/play -type f -name "play_body.dart" -print0 | xargs -0 sed -i '' \
  -e 's/AnimatedMatchGrid([^)]*cards: *\([^,)]*\))/AnimatedMatchGrid(cards: \1, sentenceId: game.currentSentenceIndex)/g'

# 4️⃣ Fix deprecated opacity call
echo "→ Replacing withOpacity() with withValues(alpha:)..."
find lib/widgets/home -type f -name "*.dart" -print0 | xargs -0 sed -i '' \
  -e 's/withOpacity(\([0-9.]*\))/withValues(alpha: \1)/g'

# 5️⃣ Remove old 'game:' named parameter usage
echo "→ Removing obsolete game: arguments..."
find lib/widgets/home -type f -name "*.dart" -print0 | xargs -0 sed -i '' \
  -e 's/game: *[^,)]*[,)]//g'

# 6️⃣ Clean unused variables (optional mild cleanup)
echo "→ Renaming unused locals to underscore-prefixed..."
find lib/widgets -type f -name "card_flip_controller.dart" -print0 | xargs -0 sed -i '' \
  -e 's/\<isMatched\>/\_isMatched/g' \
  -e 's/\<isGlowing\>/\_isGlowing/g'

# 7️⃣ Remove dead null-aware ops (?. where left cannot be null)
echo "→ Removing redundant ?. in round_card.dart..."
find lib/widgets -type f -name "round_card.dart" -print0 | xargs -0 sed -i '' \
  -e 's/\?\.\([a-zA-Z_][a-zA-Z0-9_]*\)/.\1/g'

echo "✅ Amagama controller/widget compatibility fixes applied."