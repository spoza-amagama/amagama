#!/bin/bash
set -e

PROJECT_DIR="$(pwd)"
RUNNER_PROJ="$PROJECT_DIR/macos/Runner.xcodeproj"
EPHEMERAL_SCRIPT="$PROJECT_DIR/macos/Flutter/ephemeral/run_flutter_build.sh"
PBXPROJ="$RUNNER_PROJ/project.pbxproj"

echo "🧩 Fixing Flutter macOS Run Script Phase..."

# 1️⃣ Create clean run script
mkdir -p "$(dirname "$EPHEMERAL_SCRIPT")"
cat > "$EPHEMERAL_SCRIPT" <<'SCRIPT'
#!/bin/sh
set -e
# ✅ Clean Flutter macOS build script — no deprecated flags
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
SCRIPT
chmod +x "$EPHEMERAL_SCRIPT"
echo "✅ Created clean ephemeral run script."

# 2️⃣ Patch project.pbxproj to use new script path
if grep -q "xcode_backend.sh" "$PBXPROJ"; then
  echo "🔍 Updating old script references in project.pbxproj..."
  sed -i.bak 's|/.*xcode_backend.sh.*|./Flutter/ephemeral/run_flutter_build.sh|g' "$PBXPROJ"
fi

if ! grep -q "./Flutter/ephemeral/run_flutter_build.sh" "$PBXPROJ"; then
  echo "⚠️  Did not find an existing run script in Xcode project — inserting new one..."
  echo "💡 Open Xcode > Runner target > Build Phases > Add Run Script, then paste:"
  echo "./Flutter/ephemeral/run_flutter_build.sh"
else
  echo "✅ project.pbxproj now points to ./Flutter/ephemeral/run_flutter_build.sh"
fi

# 3️⃣ Clean & rebuild environment
echo "🧹 Cleaning Flutter build and re-fetching dependencies..."
flutter clean
flutter pub get
cd macos && pod install && cd ..

echo "🚀 Ready! Now run:"
echo "flutter build macos -v"
