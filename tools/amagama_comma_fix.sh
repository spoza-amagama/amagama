#!/bin/bash
echo "🧩 Final cleanup — removing orphan commas in home widgets..."

# --- HomeContent: clean malformed HomeCarousel() + ensure bracket closure ---
if grep -q 'HomeCarousel(,' lib/widgets/home/home_content.dart 2>/dev/null; then
  sed -i '' 's/HomeCarousel(, */HomeCarousel(/g' lib/widgets/home/home_content.dart
fi

# Close any open widget list properly
sed -i '' 's/),[[:space:]]*]/)]/g' lib/widgets/home/home_content.dart
sed -i '' 's/, *],/],/g' lib/widgets/home/home_content.dart

# --- HomeHeader: remove trailing commas and ensure proper closing ---
if grep -q 'HomeTrophies(,' lib/widgets/home/home_header.dart 2>/dev/null; then
  sed -i '' 's/HomeTrophies(, */HomeTrophies(/g' lib/widgets/home/home_header.dart
fi

sed -i '' 's/),[[:space:]]*]/)]/g' lib/widgets/home/home_header.dart
sed -i '' 's/, *],/],/g' lib/widgets/home/home_header.dart

echo "🧹 Re-running dart format..."
dart format lib >/dev/null || true

echo "✅ Home widgets cleaned successfully!"
