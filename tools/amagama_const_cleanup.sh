#!/bin/zsh
# ============================================================
# Amagama Const CLEANUP Script (safe for main)
# ------------------------------------------------------------
# • Only operates on UNTRACKED Dart files
# • Removes bad "const" inserted before common widgets
# • Does NOT touch tracked files in main
# ============================================================

set -e

echo "🧹 Amagama const cleanup (untracked files only)..."

# Find all untracked Dart files
UNTRACKED_DART_FILES=$(git ls-files --others --exclude-standard | grep '\.dart$' || true)

if [[ -z "$UNTRACKED_DART_FILES" ]]; then
  echo "✅ No untracked Dart files found. Nothing to clean."
  exit 0
fi

echo "🔍 Will process these untracked Dart files:"
echo "$UNTRACKED_DART_FILES" | sed 's/^/   • /'

for file in $UNTRACKED_DART_FILES; do
  echo "   → Cleaning $file"

  # Strip unsafe consts in front of common widgets
  sed -i '' \
    -e 's/\bconst SizedBox(/SizedBox(/g' \
    -e 's/\bconst Expanded(/Expanded(/g' \
    -e 's/\bconst Padding(/Padding(/g' \
    -e 's/\bconst Center(/Center(/g' \
    -e 's/\bconst Align(/Align(/g' \
    -e 's/\bconst Text(/Text(/g' \
    -e 's/\bconst SnackBar(/SnackBar(/g' \
    -e 's/\bconst ScreenHeader(/ScreenHeader(/g' \
    -e 's/\bconst AmagamaHeader(/AmagamaHeader(/g' \
    "$file"
done

echo "🪄 Running dart format on cleaned files..."
dart format $UNTRACKED_DART_FILES >/dev/null

echo "🎉 Const cleanup complete. Re-run analyzer to verify."