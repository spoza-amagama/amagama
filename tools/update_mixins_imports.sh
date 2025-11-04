#!/bin/zsh
set -e

# 🧱 Ensure mixins folder exists
mkdir -p lib/mixins

# 1️⃣ Create / overwrite the barrel file
cat > lib/mixins/index.dart <<'EOF'
// 📦 Barrel file for all mixins in Amagama
export 'flip_animation_mixin.dart';
export 'grid_animation_mixin.dart';
export 'grid_audio_mixin.dart';
export 'match_card_effects.dart';
EOF

echo "✅ Created lib/mixins/index.dart"

# 2️⃣ Function to update all Dart files in a directory
update_imports_in_dir() {
  local dir="$1"
  echo "🔍 Processing $dir"

  find "$dir" -type f -name "*.dart" | while read -r file; do
    echo "🧩 Updating $file"

    # Remove all existing mixin imports
    sed -i '' "/package:amagama\/mixins\//d" "$file"

    # Add unified import if missing
    if ! grep -q "import 'package:amagama/mixins/index.dart';" "$file"; then
      # Insert after the first import statement
      sed -i '' "0,/^import /s//import 'package:amagama\/mixins\/index.dart';\\
&/" "$file"
    fi
  done
}

# 3️⃣ Run updates for each key folder
update_imports_in_dir "lib/widgets"
update_imports_in_dir "lib/controllers"
update_imports_in_dir "lib/screens"

echo "✨ All mixin imports updated successfully!"
