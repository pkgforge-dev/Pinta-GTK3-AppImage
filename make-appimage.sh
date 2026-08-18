#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/pinta.desktop
export ICON=/usr/share/icons/hicolor/96x96/apps/pinta.png
export ALWAYS_SOFTWARE=1 # gtk3 app

mkdir -p ./AppDir/bin
cp -r /usr/lib/pinta/* ./AppDir/bin
ln -s ./Pinta ./AppDir/bin/pinta

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
