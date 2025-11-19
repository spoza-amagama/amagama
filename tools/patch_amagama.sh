#!/bin/bash
set -e

echo "🔍 Step 1 — Removing obsolete grid & legacy service files..."

# ---------------------------------------
# 1️⃣ Delete old, broken, or deprecated files
# ---------------------------------------
rm -f lib/widgets/play/card_grid.dart
rm -f lib/widgets/play/card_cell.dart
rm -f lib/widgets/play/card_flip_controller.dart
rm -f lib/widgets/play/round_card.dart
rm -f lib/widgets/play/animated_match_grid.dart
rm -f lib/controllers/card_grid_controller.dart
rm -f lib/services/card_matcher_service.dart
rm -f lib/services/game_state_service.dart
rm -f lib/services/sentence_progress_service.dart

echo "✔ Removed deprecated grid + service files"


# ---------------------------------------
# 2️⃣ Ensure new grid structure exists
# ---------------------------------------
echo "📁 Step 2 — Rebuilding folder structure..."

mkdir -p lib/controllers
mkdir -p lib/widgets/grid
mkdir -p lib/state/services
mkdir -p lib/widgets/home
mkdir -p lib/widgets/play
mkdir -p lib/widgets/grownups
mkdir -p lib/widgets/progress

echo "✔ Folder structure updated"


# ---------------------------------------
# 3️⃣ Install new files (your patched versions)
# NOTE: These cp commands expect you have PATCHED
#       versions in a folder named patches/
# ---------------------------------------

echo "📦 Copying patched grid + service files..."

cp patches/card_grid_controller.dart lib/controllers/
cp patches/card_grid.dart lib/widgets/grid/
cp patches/card_cell.dart lib/widgets/grid/
cp patches/card_flip_controller.dart lib/widgets/grid/
cp patches/audio_trigger.dart lib/widgets/
cp patches/animated_sentence_text.dart lib/widgets/
cp patches/deck_service.dart lib/state/services/
cp patches/sentence_service.dart lib/state/services/
cp patches/cycle_service.dart lib/state/services/
cp patches/trophy_service.dart lib/state/services/
cp patches/pin_service.dart lib/state/services/
cp patches/progress_service.dart lib/state/services/
cp patches/round_service.dart lib/state/services/

echo "✔ Patched controllers + services installed"


# ---------------------------------------
# 4️⃣ Fix barrel exports automatically
# ---------------------------------------
echo "🔧 Fixing exports..."

cat > lib/widgets/index.dart <<EOF
export 'grid/card_grid.dart';
export 'grid/card_cell.dart';
export 'grid/card_flip_controller.dart';
export 'audio_trigger.dart';
export 'animated_sentence_text.dart';
EOF

cat > lib/controllers/index.dart <<EOF
export 'card_grid_controller.dart';
EOF

cat > lib/state/services/index.dart <<EOF
export 'deck_service.dart';
export 'sentence_service.dart';
export 'cycle_service.dart';
export 'progress_service.dart';
export 'pin_service.dart';
export 'round_service.dart';
export 'trophy_service.dart';
EOF

echo "✔ Barrel files updated"


# ---------------------------------------
# 5️⃣ Flutter cleanup
# ---------------------------------------
echo "🧼 Running flutter clean..."
flutter clean

echo "📦 Flutter pub get..."
flutter pub get

echo ""
echo "🎉 Patch completed successfully!"
echo "You can now run:  flutter run"