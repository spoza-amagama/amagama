#!/bin/bash
set -e

PBXPROJ="macos/Runner.xcodeproj/project.pbxproj"

echo "🩹 Patching $PBXPROJ …"

# Replace any old absolute script paths (like build/macos/.../xcode_backend.sh)
# with the clean relative one you created.
sed -i.bak \
  "s|/Users/.*/xcode_backend.sh.*|./Flutter/ephemeral/run_flutter_build.sh|g" "$PBXPROJ"

# Also remove any cached build intermediates script entries
sed -i.bak '/Script-3399D490228B24CF009A79C7.sh/d' "$PBXPROJ"

echo "✅ Patched project.pbxproj. Now cleaning…"

flutter clean
flutter pub get
cd macos && pod install && cd ..

echo "🚀 Try rebuilding:"
echo "flutter build macos -v"
