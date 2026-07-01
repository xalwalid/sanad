#!/usr/bin/env bash
# Injects release signing into the flutter-generated android/app/build.gradle.kts
# and writes android/key.properties from CI secrets. Run from the app/ dir AFTER
# `flutter create` and BEFORE `flutter build appbundle`.
set -euo pipefail
: "${ANDROID_KEYSTORE_BASE64:?missing}"
: "${ANDROID_KEYSTORE_PASSWORD:?missing}"
: "${ANDROID_KEY_ALIAS:?missing}"
: "${ANDROID_KEY_PASSWORD:?missing}"

KS="$PWD/android/app/sanad-release.jks"
echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > "$KS"

cat > android/key.properties <<EOF
storePassword=$ANDROID_KEYSTORE_PASSWORD
keyPassword=$ANDROID_KEY_PASSWORD
keyAlias=$ANDROID_KEY_ALIAS
storeFile=$KS
EOF

python3 - <<'PY'
import re
p = 'android/app/build.gradle.kts'
s = open(p).read()

if 'import java.util.Properties' not in s:
    s = 'import java.util.Properties\nimport java.io.FileInputStream\n' + s

if 'val keystoreProperties' not in s:
    m = re.search(r'plugins\s*\{.*?\n\}\n', s, re.S)
    block = ('\nval keystoreProperties = Properties()\n'
             'val keystorePropertiesFile = rootProject.file("key.properties")\n'
             'if (keystorePropertiesFile.exists()) {\n'
             '    keystoreProperties.load(FileInputStream(keystorePropertiesFile))\n'
             '}\n')
    s = s[:m.end()] + block + s[m.end():]

if 'signingConfigs {' not in s:
    sc = ('    signingConfigs {\n'
          '        create("release") {\n'
          '            keyAlias = keystoreProperties["keyAlias"] as String?\n'
          '            keyPassword = keystoreProperties["keyPassword"] as String?\n'
          '            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }\n'
          '            storePassword = keystoreProperties["storePassword"] as String?\n'
          '        }\n'
          '    }\n')
    s = s.replace('    buildTypes {', sc + '    buildTypes {', 1)

s = s.replace('signingConfigs.getByName("debug")', 'signingConfigs.getByName("release")')
open(p, 'w').write(s)
print('build.gradle.kts patched for release signing')
PY
echo "Android signing injected."
