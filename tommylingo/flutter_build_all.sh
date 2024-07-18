#!/bin/bash
set -e

echo "This is a build script for iOS, Android and MacOS. Make sure to update version in pubspec.yaml!"

echo
echo "Cleaning..."
flutter clean

echo
echo "Building iOS..."
flutter build ios

echo
echo "Building Android..."
flutter build apk
cp build/app/outputs/flutter-apk/app-release.apk dist/tommylingo.apk

echo
echo "Building MacOS..."
flutter build macos
cd build/macos/Build/Products/Release/
zip -r9 tommylingo-macos.zip tommylingo.app/
cd ../../../../..
cp build/macos/Build/Products/Release/tommylingo-macos.zip dist/

echo
echo "Done ✅"
