#!/bin/bash
set -e

echo "🧹 Fixing permissions..."
sudo chflags -R nouchg macos || true
sudo chown -R "$USER":staff macos
sudo chmod -R u+rwX macos

# Backup timestamp
ts=$(date +%Y%m%d_%H%M%S)
backup_dir="macos_backup_$ts"
echo "📦 Backing up existing macOS project to $backup_dir ..."
mkdir -p "$backup_dir"
[ -d macos/Runner.xcodeproj ] && mv macos/Runner.xcodeproj "$backup_dir"/ || true

# Extract bundle ID and app name from the old project if available
old_pbxproj=$(find "$backup_dir" -name "project.pbxproj" 2>/dev/null | head -1)
bundle_id=""
app_name=""

if [[ -f "$old_pbxproj" ]]; then
  echo "🔍 Extracting bundle ID and app name from backup..."
  bundle_id=$(grep -E "PRODUCT_BUNDLE_IDENTIFIER =" "$old_pbxproj" | head -1 | awk '{print $3}' | tr -d '";')
  app_name=$(grep -E "PRODUCT_NAME =" "$old_pbxproj" | head -1 | awk '{print $3}' | tr -d '";')
fi

echo "🧼 Cleaning Flutter build cache..."
flutter clean
rm -rf macos/Flutter/ephemeral build/macos

echo "🛠️ Recreating macOS scaffolding..."
flutter create --platforms=macos .

cd macos
echo "📦 Reinstalling CocoaPods..."
pod deintegrate || true
pod install
cd ..

echo "📚 Restoring dependencies..."
flutter pub get

# Restore bundle ID and app name if found
if [[ -n "$bundle_id" ]]; then
  echo "🔧 Restoring bundle ID: $bundle_id"
  sed -i.bak "s/com.example.amagama/$bundle_id/g" macos/Runner/Configs/AppInfo.xcconfig || true
fi

if [[ -n "$app_name" ]]; then
  echo "🔧 Restoring app name: $app_name"
  plutil -replace CFBundleName -string "$app_name" macos/Runner/Info.plist || true
  plutil -replace CFBundleDisplayName -string "$app_name" macos/Runner/Info.plist || true
fi

echo "🚀 Building macOS app..."
flutter build macos -v

echo "✅ Done! The macOS Runner project has been rebuilt and restored successfully."

