
#!/usr/bin/env bash

# Project name
PROJECT_NAME="bas"

# Path to the pico8 executable
PICO8="/Applications/pico-8/PICO-8.app/Contents/MacOS/pico8"

# Export paths relative to the script
EXPORT_PATH="bin"
BIN_EXPORT_PATH="$PROJECT_NAME.bin"

# Get the directory of the script
cd "$(dirname "$0")"

# Remove previous exported files
rm -r "$EXPORT_PATH"/*

# Export PICO-8 Cartridge
$PICO8 bas.p8 -export "$EXPORT_PATH/$PROJECT_NAME.p8.png"

# Export Web
$PICO8 bas.p8 -export "$EXPORT_PATH/${PROJECT_NAME}.html"
cd $EXPORT_PATH && mv "${PROJECT_NAME}.html" "index.html" && zip "${PROJECT_NAME}_web.zip" "index.html" "$PROJECT_NAME.js"
rm -r "$PROJECT_NAME.js" "index.html"

# Build for Win, Mac, Linux and Raspberry Pi
$PICO8 bas.p8 -export "$PROJECT_NAME.bin"
mv "$BIN_EXPORT_PATH/${PROJECT_NAME}_windows.zip" "${PROJECT_NAME}_windows.zip"
mv "$BIN_EXPORT_PATH/${PROJECT_NAME}_osx.zip" "${PROJECT_NAME}_osx.zip"
mv "$BIN_EXPORT_PATH/${PROJECT_NAME}_linux.zip" "${PROJECT_NAME}_linux.zip"
mv "$BIN_EXPORT_PATH/${PROJECT_NAME}_raspi.zip" "${PROJECT_NAME}_raspi.zip"
rm -r "$BIN_EXPORT_PATH"

cd $EXPORT_PATH && mv "${PROJECT_NAME}.html" "index.html" && zip "${PROJECT_NAME}_web.zip" "index.html" "$PROJECT_NAME.js"
rm -r "$PROJECT_NAME.js" "index.html"