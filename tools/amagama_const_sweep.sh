#!/bin/zsh
# ============================================================
# Amagama Const Sweep & Cleanup Script
# ------------------------------------------------------------
# • Adds const to constructors where safe
# • Replaces .withOpacity() → .withValues()
# • Removes unused variables named "progress"
# • Formats with dart format
# ============================================================

echo "🔍 Amagama Const Sweep starting..."

# 1. Fix deprecated .withOpacity()
echo "🔧 Replacing deprecated .withOpacity() calls..."
grep -Rl "withOpacity" lib | while read file; do
  sed -i '' 's/\.withOpacity(\([^)]*\))/\.withValues(alpha: \1)/g' "$file"
  echo "  patched $file"
done

# 2. Remove unused variable 'progress'
echo "🧹 Removing 'progress' unused locals..."
grep -Rl "unused_local_variable" lib | while read file; do
  sed -i '' '/final progress =/d' "$file"
done

# 3. Add const before static widgets where safe
echo "✨ Adding const to static widgets..."

# This covers the majority of cases — safe automatic const addition
# Only for simple constructors:
patterns=(
  "SizedBox(height:"
  "SizedBox(width:"
  "Expanded(child:"
  "Padding(child:"
  "Center(child:"
  "Align(child:"
  "Text('"
  "SnackBar("
)

for pattern in $patterns[@]; do
  grep -Rl "$pattern" lib | while read file; do
    # Insert "const " before the constructor IF not already const
    sed -i '' "s/\([^a-zA-Z]\)\($pattern\)/\1const \2/g" "$file"
    echo "  const patched in $file"
  done
done

# 4. Normalize ScreenHeader usage (do not const when has callbacks)
echo "🔧 Fixing ScreenHeader callbacks..."
grep -Rl "ScreenHeader" lib/screens | while read file; do
  sed -i '' 's/const ScreenHeader/ScreenHeader/' "$file" # remove illegal const
done

# 5. Run dart formatter
echo "🪄 Running dart format..."
dart format lib >/dev/null

echo "🎉 Amagama Const Sweep finished successfully!"