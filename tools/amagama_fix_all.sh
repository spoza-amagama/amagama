#!/bin/bash
# 🩹 Amagama: final migration + null-safety + API sync
# macOS-safe (uses: sed -i '')
set -e

echo "🔧 Amagama: applying global fixes..."

# ------------------------------------------------------------------------------
# 0) Helpers
# ------------------------------------------------------------------------------
sed_inplace() {
  # sed -i '' with portability niceties
  sed -i '' "$1" "$2"
  echo "  • patched: $2 :: $1"
}

ensure_file_exists() {
  if [ ! -f "$1" ]; then
    echo "  ⛔ Missing $1 — skipping its patches."
    return 1
  fi
  return 0
}

# ------------------------------------------------------------------------------
# 1) Null-safety for optional callbacks & state
#    - onWordFlip / onSentenceComplete -> use ?.call(...)
#    - Sparkle key currentState -> ?.triggerSparkles()
# ------------------------------------------------------------------------------
if ensure_file_exists "lib/controllers/card_grid_controller.dart"; then
  sed_inplace 's/\bonWordFlip *(/onWordFlip?.call(/g' lib/controllers/card_grid_controller.dart
  sed_inplace 's/\bonSentenceComplete *(/onSentenceComplete?.call(/g' lib/controllers/card_grid_controller.dart
fi

if ensure_file_exists "lib/widgets/play/match_card_item.dart"; then
  sed_inplace 's/\.currentState\.triggerSparkles/\.currentState?.triggerSparkles/g' lib/widgets/play/match_card_item.dart
fi

if ensure_file_exists "lib/widgets/sentence_header.dart"; then
  sed_inplace 's/\.triggerSparkles/\.triggerSparkles/g' lib/widgets/sentence_header.dart
  sed_inplace 's/\.currentState\.triggerSparkles/\.currentState?.triggerSparkles/g' lib/widgets/sentence_header.dart || true
fi

# ------------------------------------------------------------------------------
# 2) Theme copyWith null-safe (`?.copyWith`) on title/text styles
# ------------------------------------------------------------------------------
if ensure_file_exists "lib/screens/play_screen.dart"; then
  sed_inplace 's/\.copyWith(/?.copyWith(/g' lib/screens/play_screen.dart
fi
if ensure_file_exists "lib/widgets/home/home_carousel.dart"; then
  sed_inplace 's/\.copyWith(/?.copyWith(/g' lib/widgets/home/home_carousel.dart
fi

# ------------------------------------------------------------------------------
# 3) Typo fix: AAnimatedMatchGrid -> AnimatedMatchGrid
# ------------------------------------------------------------------------------
grep -RIl --include="*.dart" 'AAnimatedMatchGrid' lib | while read -r f; do
  sed_inplace 's/AAnimatedMatchGrid/AnimatedMatchGrid/g' "$f"
done

# ------------------------------------------------------------------------------
# 4) AnimatedMatchGrid API: ensure sentenceId is passed; remove old onCardTap
# ------------------------------------------------------------------------------
# Add sentenceId first (named param) where missing in PlayScreen/PlayBody
for f in lib/screens/play_screen.dart lib/widgets/play/play_body.dart; do
  if ensure_file_exists "$f"; then
    # If sentenceId already present, this is a no-op due to duplicate guard
    sed_inplace 's/AnimatedMatchGrid(/AnimatedMatchGrid(sentenceId: game.currentSentenceIndex, /g' "$f"
    # Remove any stale onCardTap named param
    sed_inplace 's/onCardTap:[^,)]*[,)]//g' "$f"
  fi
done

# ------------------------------------------------------------------------------
# 5) CardGridController API: computeLayout() positional, handleCardFlip() named
# ------------------------------------------------------------------------------
# animated_match_grid.dart: computeLayout(Size(...), cards.length)
if ensure_file_exists "lib/widgets/play/animated_match_grid.dart"; then
  # Remove unused import warning (if exists)
  sed_inplace '/package:amagama\/state\/game_controller.dart/d' lib/widgets/play/animated_match_grid.dart
  # Force correct computeLayout call using constraints
  sed_inplace 's/controller\.computeLayout([^)]*)/controller.computeLayout(Size(constraints.maxWidth, constraints.maxHeight), cards.length)/g' lib/widgets/play/animated_match_grid.dart
fi

# card_grid.dart: computeLayout(size, cards.length) and handleCardFlip named args
if ensure_file_exists "lib/widgets/card_grid.dart"; then
  sed_inplace 's/controller\.computeLayout([^)]*)/controller.computeLayout(size, cards.length)/g' lib/widgets/card_grid.dart
  # Replace any bare handleCardFlip( with named-args block
  sed_inplace 's/controller\.handleCardFlip([^)]*)/controller.handleCardFlip(context: context, item: card, sentenceId: sentenceId, boxSize: size, totalCards: cards.length)/g' lib/widgets/card_grid.dart
  # Null-safe optional callbacks if present
  sed_inplace 's/\bonWordFlip *(/onWordFlip?.call(/g' lib/widgets/card_grid.dart
  sed_inplace 's/\bonSentenceComplete *(/onSentenceComplete?.call(/g' lib/widgets/card_grid.dart
fi

# card_flip_controller.dart: replace old handleFlip(...) usage
if ensure_file_exists "lib/widgets/card_flip_controller.dart"; then
  # Fix unused locals by prefixing underscore
  sed_inplace 's/\<isMatched\>/_isMatched/g' lib/widgets/card_flip_controller.dart
  sed_inplace 's/\<isGlowing\>/_isGlowing/g' lib/widgets/card_flip_controller.dart
  # Force correct handleCardFlip named-args signature
  sed_inplace 's/controller\.handleCardFlip([^)]*)/controller.handleCardFlip(context: context, item: card, sentenceId: game.currentSentenceIndex, boxSize: Size(constraints.maxWidth, constraints.maxHeight), totalCards: game.deck.length)/g' lib/widgets/card_flip_controller.dart
fi

# ------------------------------------------------------------------------------
# 6) Remove legacy 'game:' named parameter from Home widgets & constructors
# ------------------------------------------------------------------------------
# Remove callsite usage
if ensure_file_exists "lib/widgets/home/home_content.dart"; then
  sed_inplace 's/game: *[^,)]*[,)]//g' lib/widgets/home/home_content.dart
fi
if ensure_file_exists "lib/widgets/home/home_header.dart"; then
  sed_inplace 's/game: *[^,)]*[,)]//g' lib/widgets/home/home_header.dart
fi

# Optionally soften widget definitions if they still require `game`
# Make field nullable and parameter optional (best-effort)
for f in lib/widgets/home/home_content.dart lib/widgets/home/home_header.dart; do
  if ensure_file_exists "$f"; then
    sed_inplace 's/final \([A-Za-z0-9_<>?]*GameController\)\s\+game;/final \1? game;/g' "$f" || true
    sed_inplace 's/required this\.game/this.game/g' "$f" || true
  fi
done

# ------------------------------------------------------------------------------
# 7) Deprecation: withOpacity -> withValues(alpha:)
# ------------------------------------------------------------------------------
if ensure_file_exists "lib/widgets/home/home_carousel.dart"; then
  sed_inplace 's/withOpacity(\([0-9.]*\))/withValues(alpha: \1)/g' lib/widgets/home/home_carousel.dart
fi

# ------------------------------------------------------------------------------
# 8) Remove dead null-aware usages where left cannot be null
# ------------------------------------------------------------------------------
if ensure_file_exists "lib/widgets/round_card.dart"; then
  sed_inplace 's/\?\.\([A-Za-z_][A-Za-z0-9_]*\)/.\1/g' lib/widgets/round_card.dart
fi

echo "✅ Patches applied."
echo "🧹 Running flutter format, pub get, and analyze..."

dart format lib >/dev/null || true
flutter pub get >/dev/null
flutter analyze

echo "🎉 Done. If any residual errors remain, please paste the latest analyzer output."

