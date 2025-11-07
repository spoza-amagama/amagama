#!/bin/bash
set -e

sudo chflags -R nouchg macos
sudo chown -R "$USER":staff macos
sudo chmod -R u+rwX macos

ts=$(date +%Y%m%d_%H%M%S)
mkdir -p macos_backup_$ts
[ -d macos/Runner.xcodeproj ] && mv macos/Runner.xcodeproj macos_backup_$ts/

flutter clean
rm -rf macos/Flutter/ephemeral
rm -rf build/macos

flutter create --platforms=macos .

cd macos
pod deintegrate || true
pod install
cd ..

flutter pub get
flutter build macos -v

