#!/bin/zsh
echo "🔧 FIXING Grownups imports (PACKAGE PATH MODE)…"

rewrite_imports() {
  local FILE="$1"
  echo "   → Fixing $FILE"

  sed -i '' \
    -e "s|import 'pin_dots.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_dots.dart'|g" \
    -e "s|import 'pin_keypad.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_keypad.dart'|g" \
    -e "s|import 'pin_keypad_row.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_keypad_row.dart'|g" \
    -e "s|import 'pin_keypad_button.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_keypad_button.dart'|g" \
    -e "s|import 'pin_entry_body.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_entry_body.dart'|g" \
    -e "s|import 'pin_entry_dialog_body.dart'|import 'package:amagama/widgets/grownups/pin_entry/pin_entry_dialog_body.dart'|g" \
    "$FILE"
}

FILES_TO_FIX=(
  "lib/widgets/grownups/pin_entry/pin_entry_body.dart"
  "lib/widgets/grownups/pin_entry/pin_entry_dialog_body.dart"
  "lib/widgets/grownups/pin_entry/pin_entry_flow.dart"
)

for FILE in $FILES_TO_FIX; do
  if [[ -f "$FILE" ]]; then
    rewrite_imports "$FILE"
  else
    echo "   ⚠ File missing: $FILE"
  fi
done

echo "✨ DONE — imports successfully corrected."
