rm -r export
mkdir export

# Prepare web
mkdir -p export/Web
godot --headless --export-release "Web" export/Web/index.html
zip -r export/Web.zip export/Web/

# Prepare Windows...?
godot --headless --export-release "Windows Desktop" export/Demake86_Windows_UNTESTED.zip

# Prepare Linux
godot --headless --export-release "Linux - x64" export/Demake86.x86_64
godot --headless --export-release "Linux - ARM" export/Demake86.arm64
echo "Most Linux gamers, double click 'Demake86.x86_64' to run the game!" >> export/README.md
zip -j export/Demake86_Linux.zip export/Demake86.x86_64 export/Demake86.arm64 export/Demake86.pck


# macos - haha lol. todo

butler push export/Web.zip opossumcarrion/demake86:Web
butler push export/Demake86_Windows_UNTESTED.zip opossumcarrion/demake86:Windows_UNTESTED
butler push export/Demake86_Linux.zip opossumcarrion/demake86:Linux


