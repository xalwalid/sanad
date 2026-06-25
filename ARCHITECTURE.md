# Sanad — Architecture & Foundation

*A Rakeeza product · Owner: Hussin · Last updated: 2026-06-14 · Status: pre-build (offline-first native)*

---

## 0. What changed (2026-06-14 pivot)

The original version of this doc committed Sanad to **PWA-first, with an online community and full moderation in v1**. That is superseded. The product now launches as a **native, offline-first tracker built in Flutter**, with the community and its safety layer arriving in a later phase. The reasoning and the new shape are below; the old PWA-first plan is kept only as historical context in the decisions log.

Why the pivot is the stronger product:

- The biggest barrier to recovery apps is the first 30 seconds — people won't create an account to admit a gambling or porn problem. An **offline tool with zero signup** removes that barrier entirely and delivers value on day one.
- It lets v1 ship **fast, with near-zero operational and legal risk** — no user data on our servers, no moderation burden until the community phase.
- It still feeds the growth loop: the milestone card is the marketing, and a thin web layer keeps sharing alive even though the app is native.

---

## 1. The big picture

Rakeeza is the parent company; Sanad is one of its **community-based products** (alongside Tripoli Streets and RaseedX). They share DNA — privacy-first, mobile-first, built for sharing — but serve different people and run on different stacks.

| Product | What it is | Stack (actual) | Users | Data sensitivity |
|---|---|---|---|---|
| Tripoli Streets | Live web PWA (tripolistreets.ly) — road/incident/fuel reporting | Web PWA | General public (Arabic-first) | Low |
| RaseedX | Python bot on Hetzner (staging + prod via GitHub Actions) | Python backend / bot | — | Medium |
| **Sanad** | Anonymous recovery companion | **Flutter native (iOS + Android), offline-first** | People quitting harmful habits (global) | **High** |

The guiding model is **"shared toolkit, separate apps."** Build the repeated plumbing once; each product is a thin app on top. The one thing we never share is **data** — and Sanad Phase 1 takes that further: there is no shared database because there is no server. Everything is on the device.

> **Stack note:** Sanad does **not** share the web design system with Tripoli Streets — it is a Flutter app, not a web PWA. It shares Rakeeza at the **org / infra / brand-language** level (CI/CD patterns, deploy discipline, the optimistic-human visual language), not at the code-package level. That is a deliberate trade: native + offline is worth not reusing the web UI package.

---

## 2. Stack

**Flutter** — one codebase for Android + iOS. Chosen over a Capacitor-wrapped web app and over PWA-first because Phase 1 must feel genuinely native and work with **zero connectivity**.

- **Local storage:** an on-device database (e.g. Drift/SQLite or Isar) holds all recovery data. No network calls in Phase 1.
- **State management:** to be decided at scaffold time (Riverpod is the likely default).
- **i18n:** all strings in locale files from day one — English + Arabic at launch, RTL/LTR both first-class, more languages trivially added. No hardcoded text.
- **Theming:** Sanad green identity (see §8) as a Flutter theme; structured so the palette is a single source of truth.
- **Deploy discipline:** builds and store submissions run through CI (GitHub Actions / Fastlane), never pushed from the laptop. Developer accounts (Apple + Google) already owned.

---

## 3. Phased build

### Phase 1 — Offline tracker (native, the thing we build first)

A calculator-simple, on-device recovery tracker. No account, no signup, no network.

- **Onboarding:** pick a habit category → set quit date → (optional) enter spend rate and time-per-use so savings can be computed. Pick country (for currency + future community).
- **Home screen:** the live counter — days clean, money saved, time reclaimed — with a strong visual progress indicator. Different states for day 1 vs day 33 vs post-milestone.
- **Check-in:** quick daily log of mood + craving level, optional note. Drives the streak and (later) crisis signals.
- **Milestone cards:** at 7 / 30 / 100 days (and more), auto-generate a beautiful shareable card. *The growth engine.*
- **"What to expect this week" content:** per-category guidance (e.g. cannabis week 2 vs week 6) — structure informed by established quit communities, **written by us, not copied**. Bundled with the app, works offline.
- **Relapse flow:** never framed as failure — encourages the user, resets current streak, **preserves longest streak + history**.
- **Optional backup:** user-initiated export/restore code, tied to no identity, so a lost phone doesn't erase a 200-day streak.
- **Crisis-resources screen:** a gentle "you're not alone" panel with help resources. Cheap to build, important to include even offline. Never shame, never diagnose.

### Phase 2 — Web share + landing (sanad.com.ly on Hetzner)

The native + offline choice quietly breaks the old growth loop (a shared card used to open a web link with one-tap signup; now it would point to an app-store page — more friction). Fix: keep a **thin web layer**.

- **sanad.com.ly** hosts the landing site and **card pages** — a shared milestone card resolves to a real page (the card image + "get the app" + the story of Sanad).
- Hosted on the **Hetzner** box. Static/light at first; grows into the community API host in Phase 3.

```
User hits 7 / 30 / 100 days
   → app generates a beautiful recovery card
   → user shares to WhatsApp / Facebook / Instagram
   → friends see it, tap through to sanad.com.ly card page
   → "what's Sanad?" → get-the-app → new user starts their own streak
```

### Phase 3 — Anonymous community + full safety

Only after the tracker has traction. This is where the heavy lifting (and the moderation burden) lives.

- **Accounts:** anonymous — auto-generated username + avatar. Email lives only in auth, never shown. Email + Google sign-in.
- **Community:** posts, comments, reactions; fixed habit categories first, Reddit-style user sub-groups only once moderation tooling exists.
- **Safety layer (condition of launching the community):** report button → moderation queue, block user (client + server enforced), crisis surface, rules + filtering against pro-use content. App stores **require** reporting/blocking/filtering for this category.
- **Backend:** Supabase (Postgres + Auth + Storage) in its **own isolated project** (`sanad-prod` / `sanad-dev`), FCM for push. Recovery community data never sits next to any other product — privacy + legal firewall.

---

## 4. Data model

### Phase 1 — on-device (no server)

Local tables, never leave the phone:

- **recovery** — habit_type, quit_date, spend_per_period, time_per_use, current_streak, longest_streak.
- **checkins** — date, mood, craving_level, note.
- **relapses** — date, note. *Resets current streak, preserves longest_streak + history.*
- **settings** — country, currency, locale, notification prefs.

Computed, never stored stale: `days_clean = today − quit_date`; `money_saved = days_clean × spend_per_day`; `time_saved = days_clean × time_per_day`.

### Phase 3 — server (Supabase, isolated project)

`profiles` (username, avatar, country) · `posts` · `comments` · `reactions` · `reports` (→ moderation queue) · `blocks`. RLS-protected; public identity = username + avatar only. Phase-1 on-device data stays on-device unless the user explicitly opts into syncing.

---

## 5. Safety & moderation — scaled to the phase

In a recovery space, safety is not optional — but it scales with what the product exposes.

- **Phase 1 (offline, no community):** the only safety surface needed is the **crisis-resources screen**. No user-generated content means no moderation burden. This is why v1 can ship fast.
- **Phase 3 (community):** the full stack — report, block, moderation queue, crisis surface, anti-pro-use filtering — is a **condition of launching the community**, not a later add-on.

Across both: a **relapse is never failure**. The UI encourages, preserves history, reframes around progress. Core to the mission and to retention.

---

## 6. Internationalization

International from day one. English + Arabic at launch; i18n built so more languages are trivial (all strings in locale files, no hardcoded text, RTL/LTR both first-class). Country selection at onboarding drives currency for savings and, later, community grouping.

---

## 7. Suggested build order

1. **Design the Phase-1 app flow** — home screen (day 1 vs day 33), onboarding, check-in, card, relapse, per-week content. (Next step.)
2. **Scaffold the Flutter app** — project, theming (green), i18n skeleton, local DB, CI for both stores (off-laptop).
3. **Build Phase-1 features** — tracker → cards → content → relapse → backup → crisis screen.
4. **Ship to both stores**, gather real usage.
5. **Phase 2** — sanad.com.ly landing + card pages on Hetzner.
6. **Phase 3** — Supabase backend, anonymous community, full safety layer, then enable.

---

## 8. Design language & brand

Modern, minimal, optimistic, human. Rounded cards, friendly typography, strong visual progress indicators, encouraging copy. **Avoid** hospital/clinical aesthetics and dark/depressing themes.

Sanad's own **green identity** (distinct from Rakeeza navy):

- Palette: forest green → sage/mint (growth, calm, hope).
- Typeface: **Cairo** (Arabic + Latin).
- Bilingual mark "SANAD / سند".
- Values: Trust · Support · Growth · Care.
- Assets in `brand/` (SVGs) plus logo mockups in the project folder.

---

## 9. Assets & infra in hand (2026-06-14)

- Apple + Google **developer accounts** — owned.
- Domain **sanad.com.ly** — via Libyan Spider. (Consider a global domain later if traction grows beyond Libya.)
- **Hetzner** server — rented; Phase-2 landing/card site, then Phase-3 community API.

---

## 10. Decisions log

- **2026-06-14:** Pivot to **offline-first native (Flutter)**. Phase 1 = on-device tracker, no accounts, no server. Community + full safety deferred to Phase 3.
- **2026-06-14:** Stack = **Flutter** (one codebase, iOS + Android) over Capacitor-wrap and PWA-first.
- **2026-06-14:** Growth loop revised — shared cards resolve to **sanad.com.ly** web pages (Hetzner), not just store listings.
- **2026-06-14:** Sanad brand = its **own green identity** (Cairo, forest→sage), distinct from Rakeeza navy.
- 2026-06-11: international from day one (EN + AR, RTL/LTR first-class).
- 2026-06-11: domain sanad.com.ly purchased.
- *(Superseded 2026-06-06: original plan was PWA-first in the `rakeeza-web` monorepo with online community + full moderation in v1. Replaced by the offline-first native plan above.)*

---

## 11. Open questions for Hussin

- **Per-week content sourcing** — which communities/programs do we model the structure on (r/leaves, r/stopdrinking, NHS/CDC quit timelines, etc.) before writing original copy?
- **Backup mechanism** — pure on-device export code only, or an optional anonymous cloud backup (random key, no identity) from the start?
- **Local DB choice** — Drift/SQLite vs Isar; decide at scaffold.
- **Monetization** — free forever, donations, or a later optional paid tier? Affects nothing in Phase 1 but worth deciding before stores.

---

## Sources

- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) — reporting/blocking/filtering requirements for sensitive-content apps (relevant from Phase 3).
- [Meta: Drug & Alcohol Addiction policies](https://transparency.meta.com/policies/ad-standards/restricted-goods-services/drug-alcohol-addiction-treatment/)
- [Flutter — offline-first / local persistence](https://docs.flutter.dev/data-and-backend/serialization/json) and packages Drift / Isar for on-device storage.
