rm -r export/mac
mkdir -p export/mac


# Prepare Linux
#godot --headless --export-release "Linux - x64" export/Demake86.x86_64
#zip -j export/Demake86_Linux.zip export/Demake86.x86_64 export/Demake86.arm64 export/Demake86.pck


# macos todo
godot --headless --export-release "MacOS" epxort/mac/Demake86.dmg
butler push export/Demake86_MacOS.zip opossumcarrion:demake86:macos
