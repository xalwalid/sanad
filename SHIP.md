# Sanad — Shipping runbook (Play Store first, then App Store)

Everything cloud-built and signed, no Mac needed. Mirrors the Tripoli Streets flow.
Legend: 🙋 = you do it (one-time human step) · 🤖 = Claude/CI does it.

---

## ANDROID — Google Play (do this first)

### 1) 🙋 Create the release keystore (ONE TIME — then back it up forever)
Double-click **`_gen-keystore.bat`**. Pick a strong keystore password and SAVE it
(password manager). It writes `app/keystores/sanad-release.jks`.
**Back up the .jks + password in two places.** If you lose them you can never
update Sanad on Play again.

### 2) 🙋 Add 4 GitHub secrets
Double-click **`_keystore-base64.bat`** → it writes `_keystore.b64.txt`.
In GitHub → repo **Settings → Secrets and variables → Actions → New repository secret**, add:

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | the whole contents of `_keystore.b64.txt` |
| `ANDROID_KEYSTORE_PASSWORD` | your keystore password |
| `ANDROID_KEY_ALIAS` | `sanad` |
| `ANDROID_KEY_PASSWORD` | same as keystore password (if you pressed Enter) |

(I can add these for you via the browser once the keystore exists.)

### 3) 🤖 Build the signed AAB
GitHub → **Actions → "Android release (signed AAB)" → Run workflow**.
Download the `sanad-release-aab` artifact (`app-release.aab`).

### 4) 🙋 Create the Play listing + upload
Play Console → **Create app** (name from `STORE-LISTING.md`, app, free, declarations).
Then:
- **Store listing**: title, short + full description (AR + EN), from `STORE-LISTING.md`.
- **Graphics**: app icon 512, feature graphic 1024×500, 2+ phone screenshots.
- **App content**: Privacy policy → `https://sanad.com.ly/privacy`; Data safety →
  "no data collected"; Content rating questionnaire; Target audience; Ads = No.
- **Testing → Internal testing → Create release** → upload the `.aab` → add testers
  (your email) → roll out. Install via the internal-testing link on your phone.
- When happy: **Production → Create release** → submit for review.

> First upload must be done manually in Play Console. Later we can automate
> uploads with a Play service-account JSON if you want.

---

## iOS — App Store / TestFlight (right after Android)

### A) 🙋 App Store Connect app record
Create the app in App Store Connect with bundle id **`ly.com.sanad`**, Apple
account Team **L27Z2WV29H** (same as Tripoli Streets). Note its numeric Apple ID.

### B) 🙋 Codemagic setup (reuse your TS account)
- Add the `xalwalid/sanad` repo to Codemagic.
- Reuse your existing **App Store Connect integration** (the .p8 API key).
- Edit `codemagic.yaml`: set `CODEMAGIC_ASC_INTEGRATION_NAME` to your integration
  name and `APP_STORE_APP_ID` to the numeric Apple ID from step A.

### C) 🤖 Build → TestFlight
Push (or click Start build in Codemagic). It builds the signed IPA and uploads to
TestFlight automatically. Install via TestFlight on your iPhone.

### D) 🙋 App Store listing + submit
Fill the App Store listing (name, subtitle, keywords, description, screenshots per
`STORE-LISTING.md`), App Privacy = "Data not collected", age rating, then submit
for review from App Store Connect.

---

## Status snapshot
- App code: ✅ v1.0.0, 4-tab (Community removed), iOS photo-permission wired, bundle `ly.com.sanad`.
- Privacy + Terms: ✅ live at sanad.com.ly/privacy and /terms.
- Listing copy + form answers: ✅ `STORE-LISTING.md`.
- Android signing pipeline: ✅ workflow ready — waiting on the keystore (step 1) + secrets (step 2).
- iOS pipeline: ✅ `codemagic.yaml` ready — waiting on ASC app record + Codemagic wiring.
- Still to make: feature graphic (1024×500) + phone screenshots.
