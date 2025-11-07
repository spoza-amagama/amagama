#!/bin/bash
set -e

PBXPROJ="macos/Runner.xcodeproj/project.pbxproj"

echo "🩹 Patching $PBXPROJ …"

# Point Run Script to our clean ephemeral script
# (This replaces any hard-coded xcode_backend.sh lines)
sed -i.bak \
  "s|/.*xcode_backend\.sh.*|./Flutter/ephemeral/run_flutter_build.sh|g" "$PBXPROJ" || true
sed -i.bak \
  "s|\"/bin/sh\".*xcode_backend\.sh.*|\"/bin/sh\" ./Flutter/ephemeral/run_flutter_build.sh|g" "$PBXPROJ" || true

# Also kill any stale references to build-time script files
sed -i.bak '/Script-3399D490228B24CF009A79C7\.sh/d' "$PBXPROJ" || true

# Ensure the clean script exists
mkdir -p macos/Flutter/ephemeral
cat > macos/Flutter/ephemeral/run_flutter_build.sh <<'S'
#!/bin/sh
set -e
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
S
chmod +x macos/Flutter/ephemeral/run_flutter_build.sh

echo "✅ Patched project.pbxproj and ensured ephemeral script exists."

echo "🧹 Cleaning and reinstalling pods…"
flutter clean
flutter pub get
cd macos && pod install && cd ..

echo "🚀 Now build with:  flutter build macos -v"
