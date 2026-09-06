#!/usr/bin/env bash
# Patches the regenerated iOS Info.plist. Idempotent.
# Run AFTER `flutter create` regenerates ios/, BEFORE building.
#
# 1) Photo-library usage strings for the "save achievement card to gallery"
#    feature (gal plugin). Apple rejects (error 90683) unless BOTH the add-only
#    and the general photo-library purpose strings are present.
# 2) Export-compliance flag. Sanad is fully offline and uses no non-exempt
#    encryption, so declare it here — this lets Codemagic auto-submit each build
#    to TestFlight instead of failing post-processing with "missing export
#    compliance" (which then needs answering by hand in App Store Connect).
# 3) CFBundleLocalizations = ar + en so the App Store lists Arabic as supported.
set -euo pipefail
PLIST="${1:-ios/Runner/Info.plist}"
DESC="لحفظ بطاقة إنجازك في معرض الصور · Save your Sanad achievement card to your Photos."

for KEY in NSPhotoLibraryAddUsageDescription NSPhotoLibraryUsageDescription; do
  /usr/libexec/PlistBuddy -c "Delete :$KEY" "$PLIST" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :$KEY string $DESC" "$PLIST"
done

/usr/libexec/PlistBuddy -c "Delete :ITSAppUsesNonExemptEncryption" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :ITSAppUsesNonExemptEncryption bool false" "$PLIST"

# 3) Declared localizations. Flutter apps localize via ARB/intl, not .lproj
#    folders, so without this key the App Store reads the binary as English-only
#    and suppresses Arabic search/discovery for an Arabic-first app.
/usr/libexec/PlistBuddy -c "Delete :CFBundleLocalizations" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations:0 string ar" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations:1 string en" "$PLIST"

echo "Patched $PLIST with photo-library usage strings + export-compliance flag + localizations (ar, en)"
