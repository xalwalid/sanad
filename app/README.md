# Sanad — Phase 1 app (Flutter)

Anonymous, **offline-first** recovery companion. A Rakeeza product. This is the
Phase 1 tracker: on-device only, no accounts, no network. Community and the full
safety layer come in Phase 3 (see `../ARCHITECTURE.md`).

> **2026-06-25 — rebuilt to the design hand-off.** Now **bilingual AR + EN with RTL**,
> deeper-green/cream palette (`SanadColors` in `theme/sanad_theme.dart`), multi-step
> onboarding (`welcome → habit → date → spend`), a **13-metric health recovery timeline**
> (`screens/health_screen.dart`, data in `data/catalog.dart`), and a **selective-disclosure
> share card** that can hide money/time/units/mass *and the habit type* (`milestone_card_screen.dart`).
> UI copy lives bilingually in `data/strings.dart`. Numerals are always Western digits.
> `screens/weekly_content_screen.dart` + `logic/content_service.dart` are superseded stubs
> (kept only because files can't be deleted here — safe to remove from the repo).
> Not yet wired: bundle the Cairo font, and the in-onboarding calendar uses the native
> date picker for now.

## What's here

```
app/
├─ lib/
│  ├─ main.dart                 # app entry, locale, routes to onboarding/home
│  ├─ theme/sanad_theme.dart    # green identity — single source of color
│  ├─ models/models.dart        # RecoveryProfile, CheckIn, Relapse, Habit
│  ├─ logic/
│  │  ├─ calculations.dart      # days clean, money/time saved, milestones
│  │  └─ content_service.dart   # loads bundled "what to expect" content
│  ├─ data/local_store.dart     # on-device persistence (+ identity-free backup)
│  ├─ state/app_state.dart      # ChangeNotifier app truth
│  ├─ widgets/progress_ring.dart
│  ├─ screens/                  # onboarding, home, check-in, card, relapse, crisis, weekly
│  └─ l10n/                     # app_en.arb, app_ar.arb (EN + AR, RTL ready)
├─ assets/content/weekly_en.json  # offline per-habit guidance
└─ analysis_options.yaml
```

## Run it

```bash
cd products/sanad/app
flutter pub get
flutter gen-l10n        # generates L10n from the .arb files
flutter run
```

Requires Flutter 3.29+ (Dart 3.3+). The theme uses `CardThemeData`, which needs a
recent stable Flutter — if you're on an older SDK, run `flutter upgrade` first.

## Design intent (so the next change stays on-brand)

- **Offline is the promise.** No screen makes a network call in Phase 1. The
  only "backup" is `LocalStore.exportBackup()` — an identity-free JSON blob.
- **Green identity** lives entirely in `SanadColors`. Don't hardcode colors in
  widgets; add to the palette.
- **Relapse is never failure** — `AppState.logRelapse()` keeps `longestStreakDays`
  and writes a `Relapse` record before resetting the quit date.
- **The card is the growth engine.** `milestone_card_screen.dart` renders a
  fully-branded card, lets the user pick which stats show, captures it via
  `RepaintBoundary`, and shares a PNG. It carries `sanad.com.ly` so Phase 2 web
  card pages can mirror it.

## Wired but needs finishing

- **i18n in screens.** The `.arb` files + `l10n.yaml` are ready; screens still
  use literal English strings. Run `flutter gen-l10n`, then replace literals with
  `L10n.of(context)` and uncomment the delegate in `main.dart`.
- **Cairo font.** Bundle the `.ttf` files in `assets/fonts/`, uncomment the fonts
  block in `pubspec.yaml`, and set `SanadTheme.fontFamily = 'Cairo'`. Kept
  offline on purpose (no `google_fonts` network fetch).
- **Local DB.** `LocalStore` uses SharedPreferences for the scaffold. Swap to
  Drift/SQLite or Isar behind the same methods once history/insights need it.
- **Crisis resources** are placeholders — localize per country before launch
  (open question in the spec).

## Content note

`weekly_en.json` is **original copy**; timelines are informed by public
withdrawal-recovery references but the wording is ours. The alcohol entry carries
a deliberate medical-safety caution — alcohol withdrawal can be dangerous. Keep
that tone: supportive, never clinical, never shaming. Don't paste text from other
apps or forums (see the spec's sourcing open question).

## Build & ship — off-laptop only

CI lives at the repo root: `.github/workflows/sanad-app-build.yml` (analyze →
test → Android appbundle + iOS build). Store signing keys go in GitHub secrets,
never in the repo. Never build or publish from a local machine — Rakeeza standing
rule.
