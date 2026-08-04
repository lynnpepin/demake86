rm -r export/mac
mkdir -p export/mac

godot --headless --export-release "macOS" export/mac/index.dmg
butler push export/mac/index.dmg opossumcarrion/demake86:macos
