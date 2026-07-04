#!/usr/bin/env bash
# Adds the photo-library usage strings Apple requires for the "save
# achievement card to gallery" feature (gal plugin). Idempotent.
# Apple rejects the build (error 90683) unless BOTH the add-only and the
# general photo-library purpose strings are present.
# Run AFTER `flutter create` regenerates ios/, BEFORE building.
set -euo pipefail
PLIST="${1:-ios/Runner/Info.plist}"
DESC="لحفظ بطاقة إنجازك في معرض الصور · Save your Sanad achievement card to your Photos."
for KEY in NSPhotoLibraryAddUsageDescription NSPhotoLibraryUsageDescription; do
  /usr/libexec/PlistBuddy -c "Delete :$KEY" "$PLIST" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :$KEY string $DESC" "$PLIST"
done
echo "Patched $PLIST with photo-library usage strings (Add + Usage)"
