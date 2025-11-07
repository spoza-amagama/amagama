#!/bin/bash
set -e

APP_INFO="macos/Runner/Configs/AppInfo.xcconfig"

echo "🧩 Patching CocoaPods includes in $APP_INFO ..."

# Create file if missing
if [ ! -f "$APP_INFO" ]; then
  mkdir -p "$(dirname "$APP_INFO")"
  touch "$APP_INFO"
fi

# Ensure includes exist at top of file
INCLUDES=$(cat <<'INCS'
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

INCS
)

if ! grep -q "Pods-Runner.debug.xcconfig" "$APP_INFO"; then
  echo "$INCLUDES$(cat "$APP_INFO")" > "$APP_INFO"
  echo "✅ Added CocoaPods includes."
else
  echo "✅ CocoaPods includes already present."
fi
