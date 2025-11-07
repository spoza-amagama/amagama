#!/bin/bash
set -e

PROJECT_PATH="macos/Runner.xcodeproj"
BUILD_DIR="build/macos/Build/Intermediates.noindex/Runner.build"
SCRIPT_FILE_PATTERN="Script-*.sh"

echo "🔍 Searching for Xcode Run Script files..."
SCRIPT_FILES=$(find "$BUILD_DIR" -name "$SCRIPT_FILE_PATTERN" 2>/dev/null || true)

if [ -z "$SCRIPT_FILES" ]; then
  echo "⚠️  No built script files found yet — build once in Xcode to generate them."
  echo "Then rerun this script."
  exit 0
fi

for FILE in $SCRIPT_FILES; do
  echo "🧹 Fixing Run Script in: $FILE"
  cat > "$FILE" <<'SCRIPT'
#!/bin/sh
# ✅ Clean Flutter macOS build script (no --target-platform)
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
SCRIPT
  chmod +x "$FILE"
done

echo "✅ Run script phases cleaned up successfully!"
