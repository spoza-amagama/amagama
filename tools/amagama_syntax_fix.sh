#!/bin/bash
echo "🩹 Fixing syntax errors introduced by previous patch..."

# --- 1️⃣ Fix accidental '??.copyWith' typo → '?.copyWith' ---
if grep -q '??.copyWith' lib/screens/play_screen.dart 2>/dev/null; then
  sed -i '' 's/\?\?\.copyWith/?.copyWith/g' lib/screens/play_screen.dart
  echo "✅ Fixed copyWith operator in play_screen.dart"
fi
if grep -q '??.copyWith' lib/widgets/home/home_carousel.dart 2>/dev/null; then
  sed -i '' 's/\?\?\.copyWith/?.copyWith/g' lib/widgets/home/home_carousel.dart
  echo "✅ Fixed copyWith operator in home_carousel.dart"
fi

# --- 2️⃣ Remove stray commas in Home widgets introduced by auto-patch ---
# HomeContent
if grep -q 'HomeHeader' lib/widgets/home/home_content.dart 2>/dev/null; then
  sed -i '' 's/isSmall: isSmall, ,/isSmall: isSmall,/g' lib/widgets/home/home_content.dart
  sed -i '' 's/HomeCarousel(, /HomeCarousel(/g' lib/widgets/home/home_content.dart
  sed -i '' 's/HomeCarousel(,)/HomeCarousel()/g' lib/widgets/home/home_content.dart
  echo "✅ Cleaned commas in home_content.dart"
fi

# HomeHeader
if grep -q 'HomeTrophies' lib/widgets/home/home_header.dart 2>/dev/null; then
  sed -i '' 's/HomeTrophies(, /HomeTrophies(/g' lib/widgets/home/home_header.dart
  sed -i '' 's/HomeTrophies(,)/HomeTrophies()/g' lib/widgets/home/home_header.dart
  echo "✅ Cleaned commas in home_header.dart"
fi

echo "🧹 Running formatter..."
dart format lib >/dev/null || true

echo "✅ All syntax and null-safety fixes applied!"
