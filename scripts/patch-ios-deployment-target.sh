#!/usr/bin/env bash
# Raises the iOS deployment target of the regenerated ios/ folder. Idempotent.
# Run AFTER `flutter create` regenerates ios/, BEFORE building.
#
# `flutter create` (Flutter 3.29) scaffolds iOS 12.0. App Store Connect started
# rejecting uploads with MinimumOSVersion 12.0 in Sept 2026 (ITMS-90068) and
# requires 15.0+ from spring 2027, so we pin 15.0 in the three places the
# bundle's MinimumOSVersion comes from.
set -euo pipefail
TARGET="${1:-15.0}"
IOS="${2:-ios}"

sed -i '' -E "s/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]+;/IPHONEOS_DEPLOYMENT_TARGET = ${TARGET};/g" "$IOS/Runner.xcodeproj/project.pbxproj"
sed -i '' -E "s/^# *platform :ios, '[0-9.]+'/platform :ios, '${TARGET}'/" "$IOS/Podfile"
/usr/libexec/PlistBuddy -c "Set :MinimumOSVersion ${TARGET}" "$IOS/Flutter/AppFrameworkInfo.plist"

grep -q "IPHONEOS_DEPLOYMENT_TARGET = ${TARGET};" "$IOS/Runner.xcodeproj/project.pbxproj" || { echo "pbxproj patch failed"; exit 1; }
grep -q "^platform :ios, '${TARGET}'" "$IOS/Podfile" || { echo "Podfile patch failed"; exit 1; }
echo "iOS deployment target set to ${TARGET}"
