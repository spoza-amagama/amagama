#!/bin/bash
# ---------------------------------------------------------------------
# 🛠️ Amagama Project Auto-Patch Script (v2)
# - Fixes HomeBackground parameter usage
# - Ensures correct SentenceStack import path
# - Cleans unused variables, runs dart fix & analyze
# ---------------------------------------------------------------------

set -e

echo "🔧 Starting Amagama patch (v2)..."

# 1️⃣ Backups
mkdir -p .backup_amagama
for f in lib/screens/home_screen.dart lib/widgets/play/animated_sentence_header.dart; do
  if [ -f "$f" ]; then
    cp "$f" ".backup_amagama/$(basename "$f")"
    echo "📦 Backed up $f"
  fi
done

# 2️⃣ Fix HomeBackground call — replace any parameterized constructor with const default
echo "🏠 Fixing HomeBackground constructor..."
sed -i '' -E "s/bg\.HomeBackground\(.*\)/const bg.HomeBackground(),/g" lib/screens/home_screen.dart || true

# 3️⃣ Fix SentenceStack import path
echo "📚 Correcting SentenceStack import..."
# Remove any relative import for sentence_stack.dart
sed -i '' "/sentence_stack\.dart/d" lib/widgets/play/animated_sentence_header.dart || true
# Add correct package import if missing
grep -q "import 'package:amagama/widgets/play/sentence_stack.dart';" lib/widgets/play/animated_sentence_header.dart || \
  sed -i '' "1 i\\
import 'package:amagama/widgets/play/sentence_stack.dart';\\
" lib/widgets/play/animated_sentence_header.dart

# 4️⃣ Clean unused locals
echo "🧹 Cleaning unused local variables..."
sed -i '' '/final theme = /d' lib/screens/home_screen.dart || true
sed -i '' '/final textTheme = /d' lib/screens/game_over_screen.dart || true
sed -i '' '/final colorScheme = /d' lib/screens/play_screen.dart || true

# 5️⃣ Run dart fix and analyzer
echo "⚙️ Running dart fix and analyzer..."
dart fix --apply || true
dart analyze || true

echo "✅ Amagama patch complete!"
