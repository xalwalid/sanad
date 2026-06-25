# Getting Sanad onto your phone

Plain-language steps. No coding, no toolchain on your laptop — the build happens
in the cloud (GitHub Actions) and you download the finished app.

## One-time setup

1. Put this project in a GitHub repo (you already deploy other projects this way).
   The app lives at `products/sanad/app`, and the build file is at
   `.github/workflows/sanad-app-build.yml` — it must sit at the **repo root**.
2. That's it. No keys or accounts to configure for a test build.

## Each time you want a fresh build on your phone

1. **Trigger the build.** Either push a change to the `main` (or `staging`) branch,
   or go to your repo on GitHub → **Actions** tab → **Sanad app build** → **Run workflow**.
2. **Wait ~10–15 minutes.** GitHub builds it for you. A green check means it's done.
3. **Download the app.** Open the finished run → scroll to **Artifacts** →
   download **`sanad-apk`**. Unzip it — inside is `app-release.apk`.

## Install on an Android phone

1. Send `app-release.apk` to your phone (WhatsApp to yourself, email, or USB).
2. Tap it. Android will say "for your security, you can't install from this source" —
   tap **Settings**, allow **Install unknown apps** for whichever app you opened it from
   (Files, WhatsApp, etc.), then go back and tap **Install**.
3. Open Sanad. Done — it runs fully offline.

> This APK is a test build (debug-signed). It's perfect for trying it on your own
> phones and sharing with a few people. For the Play Store you'll publish the
> `sanad-android-aab` artifact with a proper signing key (a later step).

## iPhone

The APK above is Android-only. iPhone is more involved: it needs a Mac with Xcode
and your Apple signing certificates to put the app on a device or TestFlight. The
CI already compiles the iOS build to prove it works; when you're ready to test on
an iPhone, that's the next setup (Apple API key + certs in GitHub secrets, then
`flutter build ipa` → TestFlight). Tell me when you want to do that.

## If a build fails

Open the failed run on GitHub, click the red step, and copy the error to me — these
first builds usually need a couple of small fixups, which is normal.
