# Sanad (سند) — a Rakeeza product

Parent: Rakeeza for Digital Marketing (ركيزة) · Manager: Hussin Alwalid · +218 92 707 1404

## What this product is

Sanad is an **anonymous, anti-shame recovery companion** for people quitting harmful habits (cannabis, alcohol, cigarettes, vaping, gambling, porn, and more). It is **not** a medical, therapy, rehab, or diagnostic service — it is a supportive tool and, later, a community.

It launches as a **native, offline-first tracker**: you set a quit date and the app shows your days clean, money and time saved, lets you log mood and cravings, and celebrates milestones with a beautiful shareable card. Everything stays on your phone — no account, no signup, nothing leaves the device. The anonymous community comes in a later phase, on top of that trusted base.

## Status (2026-06-25)

**A high-fidelity design hand-off has arrived and is now the design source of truth** (`Recovery app design integration/design_handoff_sanad/`). It supersedes the earlier in-house HTML prototype. Direction now being built **straight into Flutter, bilingual AR + EN with RTL**. The hand-off is Arabic-first, RTL, with a deeper green `#1B4D3E` on a warm cream page `#F3F0E8` (not the earlier forest/mint), Cairo type, and a firm rule: **numerals are always Western digits (1234), never Arabic-Indic**. New/expanded screens vs. the old prototype: multi-step onboarding (welcome → habit → date → spend with 3-step progress + toggled cost/time/usage setup), a 13-metric **health recovery timeline** (semicircular gauges sorted by remaining days, plus a per-metric recovery-curve detail chart with an RTL time axis), and a 30-day **achievement/share card with full selective disclosure** — the user can independently hide money, time, units, mass avoided, AND the habit type itself, so they can share numbers without revealing what they're recovering from. Milestones: 7/30/100/365. Build order: theme tokens → data catalog (habits + 13 metrics) → models/calc → onboarding → home → health/share/checkin/relapse.

### Earlier status (2026-06-19)

Pre-build, but the **Phase-1 app flow is now prototyped**. This week a full, polished interactive prototype was built (standalone HTML, opened full-screen in browser) modeled on what the leading recovery apps actually do — I Am Sober, Nomo, Reframe, Quit Genius (researched directly). It includes: a live ticking sober clock with gradient hero + progress bar to next milestone; a daily pledge button with motivation quote; a reclaimed-stats grid (money, time, units avoided, health); a red SOS "ride the wave" craving button that opens a breathing-exercise overlay; a five-tab bottom nav (Home, Progress, Learn, Community, Me); mood + craving charts, a clean-days calendar, an earned/locked milestone badge grid; a personalized withdrawal timeline (Learn); a Phase-3 community teaser with sample anonymous posts; reasons-for-quitting, multi-habit tracking, privacy/backup/language controls (Me); the shareable card; and the no-shame relapse flow. Green theme throughout.

**Open design calls for Hussin** (asked at end of prototype session): is the green direction right or should it be bolder/darker; should Nomo-style multi-habit clocks be front-and-center; how heavy should gamification (badges, levels, streak pressure) be given the anti-shame mission. **Stack decided: Flutter** native (Android + iOS). The HTML prototype is design exploration only — the real build is still Flutter and **not yet scaffolded**. Next: lock the design from prototype feedback → scaffold the Flutter app → on-device data model.

Note: this session was titled "Summit platform concept" but the work is unambiguously Sanad (recovery tracker, green identity, anti-shame, Phase-3 community).

## The pivot (2026-06-14)

The earlier plan was PWA-first with an online community and full moderation in v1. New direction:

- **Native apps, not PWA** — Flutter, one codebase, both stores. Developer accounts already owned.
- **Offline-first** — Phase 1 is a calculator-simple tracker; all data lives on the device, zero signup. This removes the single biggest barrier to recovery apps: nobody wants to create an account to admit a problem.
- **Community is a later phase** — the Reddit-style anonymous sharing, accounts, and the heavy safety/moderation layer move to Phase 3. This lets v1 ship fast with near-zero operational and legal risk.

## Phases

1. **Offline tracker (native, Flutter).** Quit date → days clean, money + time saved, mood + craving log, milestone cards, per-category "what to expect this week" content, optional backup code, crisis-resources screen. All on-device.
2. **Web share + landing (sanad.com.ly, Hetzner).** Shared cards resolve to a real web page (card image + "get the app"). Keeps the growth loop alive even though the app is native.
3. **Anonymous community.** Accounts, posts/comments/reactions, topic groups — plus the full safety layer (report, block, moderation queue, crisis surface). Backend on Supabase/Hetzner.

## Sanad-specific rules

- **Offline means offline.** Phase 1 data never leaves the device. Backup is an optional, user-initiated export code — tied to no identity.
- **Safety scales with the product.** Phase 1 carries a crisis-resources screen (cheap, important). The full moderation stack is a *condition of launching the community* (Phase 3), not of launching the tracker.
- **Recovery data isolation.** When the community ships, its data lives in its own isolated Supabase project. Never shared. Non-negotiable.
- **Recovery is not linear.** A relapse is never "failure" — the UI encourages the user, resets the current streak but preserves longest streak and history.

## Brand

Sanad has its **own green identity**, distinct from the navy Rakeeza palette:

- Palette: forest green → sage/mint greens (growth, calm, hope).
- Typeface: **Cairo** (excellent Arabic + Latin).
- Bilingual mark: "SANAD / سند".
- Values: Trust · Support · Growth · Care.
- Assets: brand SVGs + logo mockups in `brand/`.

Green reads as growth and calm — the right emotional register for recovery. Sanad themes the shared Rakeeza toolkit in green rather than navy.

## Rakeeza standing rules (inherited)

1. Deploy via git push + GitHub Actions only — never from the laptop.
2. Built-in growth loop (shareable cards/links) in every product.
3. Isolated database per product (applies once Sanad has a backend).
4. Design language: modern, minimal, optimistic, human. No hospital/clinical aesthetics.

## Assets & infra in hand (2026-06-14)

- Apple + Google **developer accounts** — owned.
- Domain **sanad.com.ly** — bought via Libyan Spider. (International product on a `.ly`; consider a global domain later if traction grows outside Libya.)
- **Hetzner** server — rented; will host the Phase-2 landing/card site and the Phase-3 community API.

## Decisions log

- 2026-06-25: **Design hand-off received → now the design source of truth**; superseded the in-house prototype. Building **straight to Flutter, bilingual AR + EN + RTL**. Palette set to deeper green `#1B4D3E` on cream `#F3F0E8`; Western numerals always; added the 13-metric health timeline and the selective-disclosure share card (incl. hiding habit type). Hand-off lives in `Recovery app design integration/design_handoff_sanad/`.
- 2026-06-19: **Phase-1 interactive prototype built** (standalone HTML, full-screen browser) — sober clock, daily pledge, reclaimed-stats grid, SOS breathing overlay, 5-tab nav, mood/craving charts, milestone badges, withdrawal timeline, Phase-3 community teaser, multi-habit, share card, no-shame relapse flow. Benchmarked against I Am Sober / Nomo / Reframe / Quit Genius. Design-only; Flutter build still pending. Open Hussin calls: green shade (bolder/darker?), prominence of multi-habit clocks, gamification intensity vs. anti-shame mission.
- 2026-06-14: **Pivot to offline-first native (Flutter).** Phase 1 = on-device tracker, no accounts. Community + full safety move to Phase 3.
- 2026-06-14: **Stack = Flutter** (iOS + Android, one codebase) — chosen over Capacitor-wrap and PWA-first for true offline + native feel.
- 2026-06-14: Sanad brand confirmed as its **own green identity** (Cairo, forest→sage), distinct from Rakeeza navy.
- 2026-06-14: Growth loop revised — shared cards point to a **sanad.com.ly** web page, not just an app-store listing.
- 2026-06-11: international from day one — English + Arabic at launch, i18n architecture so more languages are trivial (locale files, no hardcoded strings, RTL/LTR both first-class).
- 2026-06-11: domain sanad.com.ly purchased.
