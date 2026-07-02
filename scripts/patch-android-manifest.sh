#!/usr/bin/env bash
# Adds a <queries> block so url_launcher can open https + mailto on Android 11+.
# Run from the app/ dir AFTER `flutter create`, BEFORE building. Idempotent.
set -euo pipefail
M="android/app/src/main/AndroidManifest.xml"
python3 - "$M" <<'PY'
import sys
p=sys.argv[1]
s=open(p,encoding='utf-8').read()
if '<queries>' in s:
    print('queries already present'); sys.exit(0)
block='''    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
        <intent>
            <action android:name="android.intent.action.SENDTO" />
            <data android:scheme="mailto" />
        </intent>
    </queries>
'''
# insert right after the opening <manifest ...> tag
i=s.index('>', s.index('<manifest'))+1
s=s[:i]+'\n'+block+s[i:]
open(p,'w',encoding='utf-8').write(s)
print('AndroidManifest queries injected')
PY
