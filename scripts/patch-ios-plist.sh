#!/usr/bin/env bash
# Adds the photo-library usage string Apple requires for the "save
# achievement card to gallery" feature (gal plugin). Idempotent.
# Run AFTER `flutter create` regenerates ios/, BEFORE building.
set -euo pipefail
PLIST="${1:-ios/Runner/Info.plist}"
DESC="لحفظ بطاقة إنجازك في معرض الصور · Save your Sanad achievement card to your Photos."
/usr/libexec/PlistBuddy -c "Delete :NSPhotoLibraryAddUsageDescription" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :NSPhotoLibraryAddUsageDescription string $DESC" "$PLIST"
echo "Patched $PLIST with NSPhotoLibraryAddUsageDescription"
