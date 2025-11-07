#!/bin/bash
set -e

PBXPROJ="macos/Runner.xcodeproj/project.pbxproj"

echo "🩹 Injecting clean Flutter Run Script phase into $PBXPROJ ..."

# Remove any broken or old Run Script phases
sed -i.bak '/xcode_backend.sh/d' "$PBXPROJ"
sed -i.bak '/Script-3399D490228B24CF009A79C7/d' "$PBXPROJ"

# Add a valid Flutter build script reference if missing
if ! grep -q "run_flutter_build.sh" "$PBXPROJ"; then
  cat <<'SCRIPT' >> "$PBXPROJ"

// Added by fix_flutter_run_phase.sh
/* Begin PBXShellScriptBuildPhase section */
		NEWFLUTTERPHASE = {
			isa = PBXShellScriptBuildPhase;
			buildActionMask = 2147483647;
			files = ( );
			inputPaths = ( );
			name = "Run Flutter Build";
			outputPaths = ( );
			runOnlyForDeploymentPostprocessing = 0;
			shellPath = /bin/sh;
			shellScript = "./Flutter/ephemeral/run_flutter_build.sh";
			showEnvVarsInLog = 0;
		};
/* End PBXShellScriptBuildPhase section */

SCRIPT
fi

echo "✅ Flutter Run Script added. Cleaning up..."
flutter clean
flutter pub get
cd macos && pod install && cd ..

echo "🚀 Now try:"
echo "flutter build macos -v"
