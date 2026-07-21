#!/usr/bin/env bash
set -euo pipefail

APP_NAME="OpiumHzEngine"
BUILD_DIR="./build/$APP_NAME.app/Contents/MacOS"

echo "🧹 Clearing previous artifacts..."
rm -rf ./build
mkdir -p "$BUILD_DIR"

echo "⚙️ Compiling native AppKit Controller layer..."
# Compiles main UI application component
swiftc main.swift -o "$BUILD_DIR/$APP_NAME" -target arm64-apple-macos11.0

echo "⚙️ Compiling 360Hz CoreGraphics Display Driver..."
# Compiles the standalone background monitor driver binary
swiftc display.swift -o "$BUILD_DIR/opium_display_driver" -target arm64-apple-macos11.0

echo "🛡️ Injecting localized ad-hoc code-signing signature..."
codesign --force --sign - "$BUILD_DIR/$APP_NAME"
codesign --force --sign - "$BUILD_DIR/opium_display_driver"

echo "✔ Compilation matrix successfully created at ./build/$APP_NAME.app"