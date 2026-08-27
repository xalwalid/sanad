#!/usr/bin/env bash
# Force the generated Android project to compile/target API 36 (Android 16).
#
# Why this exists: the repo does NOT commit android/ — CI regenerates it with
# `flutter create`, so we can't just edit build.gradle once. Flutter 3.29's
# template targets API 35, but Google Play requires API 36 for any app update
# from Aug 31, 2026. This patches the freshly generated files in place, the same
# way scripts/patch-ios-plist.sh patches Info.plist.
#
# Run from the Flutter app dir (app/) AFTER `flutter create`:
#   bash ../scripts/patch-android-sdk.sh
set -euo pipefail

SDK=36
AGP=8.9.1          # first AGP line that supports compileSdk 36
GRADLE=8.11.1      # Gradle required by AGP 8.9.x

say() { echo "[patch-android-sdk] $*"; }

# ---------- app/build.gradle(.kts): compileSdk + targetSdk ----------
APP_GRADLE=""
for f in android/app/build.gradle.kts android/app/build.gradle; do
  [ -f "$f" ] && APP_GRADLE="$f" && break
done
[ -n "$APP_GRADLE" ] || { echo "ERROR: android/app/build.gradle(.kts) not found"; exit 1; }
say "patching $APP_GRADLE"

# Kotlin DSL:  compileSdk = flutter.compileSdkVersion   /  targetSdk = flutter.targetSdkVersion
sed -i.bak -E "s/compileSdk[[:space:]]*=[[:space:]]*flutter\.compileSdkVersion/compileSdk = ${SDK}/" "$APP_GRADLE"
sed -i.bak -E "s/targetSdk[[:space:]]*=[[:space:]]*flutter\.targetSdkVersion/targetSdk = ${SDK}/"   "$APP_GRADLE"
# Groovy DSL: compileSdkVersion flutter.compileSdkVersion / targetSdkVersion flutter.targetSdkVersion
sed -i.bak -E "s/compileSdk(Version)?[[:space:]]+flutter\.compileSdkVersion/compileSdk ${SDK}/" "$APP_GRADLE"
sed -i.bak -E "s/targetSdk(Version)?[[:space:]]+flutter\.targetSdkVersion/targetSdk ${SDK}/"   "$APP_GRADLE"
rm -f "${APP_GRADLE}.bak"

grep -nE "compileSdk|targetSdk" "$APP_GRADLE" || true
if grep -qE "flutter\.(compile|target)SdkVersion" "$APP_GRADLE"; then
  echo "ERROR: SDK placeholders still present in $APP_GRADLE"; exit 1
fi

# ---------- settings.gradle(.kts): Android Gradle Plugin version ----------
for f in android/settings.gradle.kts android/settings.gradle; do
  if [ -f "$f" ]; then
    say "patching AGP -> ${AGP} in $f"
    sed -i.bak -E "s/(id[( ]\"com\.android\.application\"[)]?[[:space:]]+version[[:space:]]+)\"[0-9]+\.[0-9]+\.[0-9]+\"/\1\"${AGP}\"/" "$f"
    rm -f "${f}.bak"
    grep -n "com.android.application" "$f" || true
  fi
done

# ---------- gradle wrapper ----------
WRAP=android/gradle/wrapper/gradle-wrapper.properties
if [ -f "$WRAP" ]; then
  say "patching Gradle wrapper -> ${GRADLE}"
  sed -i.bak -E "s#gradle-[0-9]+\.[0-9]+(\.[0-9]+)?-(all|bin)\.zip#gradle-${GRADLE}-all.zip#" "$WRAP"
  rm -f "${WRAP}.bak"
  grep -n distributionUrl "$WRAP" || true
fi

say "done — compiling/targeting API ${SDK}"
