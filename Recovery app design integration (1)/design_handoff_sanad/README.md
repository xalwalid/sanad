# Handoff: Sanad (سند) — Recovery / Sobriety App

## Overview
Sanad is a **privacy-first, Arabic (RTL) recovery companion** for quitting an addictive habit (cannabis, alcohol, cigarettes, vaping, gambling, porn, or "other"). The user picks a habit, sets a quit date, optionally enters spending/time/usage, then lands on a home dashboard with a live "clean for" counter, savings stats, a daily check-in, a recovery-timeline ("what's healing now"), a 30-day achievement/share card, and a relapse-reset flow.

Core product principles to preserve in the rebuild:
- **Everything stays on device** — no account, no server, no tracking. Explicitly promised on the welcome screen.
- **Arabic-first, RTL** throughout. UI copy is all Arabic; the device frame and layout are mirrored (`dir="rtl"`).
- **Numerals are always standard Western digits (1234)** — never Arabic-Indic (٠١٢٣). This is a firm requirement.
- **Privacy of disclosure** — on the achievement/share card the user can independently hide money saved, time reclaimed, units avoided, mass avoided, AND the drug/habit type, so they can share numbers without revealing what they're recovering from.

## About the Design Files
The files in this bundle are **design references created in HTML** — a working prototype that shows the intended look, copy, and behavior. They are **not production code to ship directly.**

The prototype is built as a "Design Component" (`.dc.html`) — a custom in-house HTML runtime (`support.js`) with a small template syntax (`<sc-if>`, `<sc-for>`, `{{ }}` holes) and a `Component extends DCLogic` class that behaves like a React class component. **Do not try to port the `.dc.html` runtime.** Instead, **recreate these screens in the target codebase's environment** (React Native / Swift / Flutter / React, etc.) using its established patterns. The logic class maps cleanly onto a normal React component: `state` → component state, `renderVals()` → derived/computed values + handlers, `<sc-if value>` → conditional render, `{{ x }}` → interpolation.

If no codebase exists yet: this is a phone app, so **React Native (or native SwiftUI/Kotlin)** is the natural target. Build full RTL support in from day one.

## Fidelity
**High-fidelity (hifi).** Final colors, typography, spacing, copy, and interactions are all here and should be reproduced faithfully. Exact hex values, font sizes, and radii are listed below and are present inline in the HTML.

## Tech / Layout Frame
- Designed for a single phone screen: **402 × 874 px** (iPhone-class), rendered inside an iOS device frame in the prototype (`ios-frame.jsx` — just a bezel mock, not part of the app).
- Root container is `dir="rtl"`, `font-family: 'Cairo'` (Google Font, weights 400–900), background `#F3F0E8`.
- Single scrolling column per screen; custom thin/hidden scrollbars.
- The app is a **screen state machine** — one of these is visible at a time, driven by `state.screen`: `welcome → habit → date → spend → home`, plus `checkin`, `health`, `relapse`, `relapseDone` reachable from home, and a share sheet + metric-detail sheet overlaid on top.

## Screens / Views

### 1. Welcome (`welcome`)
- **Purpose:** First-run intro + privacy promise.
- **Layout:** Centered logo card (`assets/sanad-logo.png`, 236px wide white rounded card, radius 30, shadow), title "أهلاً بك في سند" (29px / 800), subtitle. A white privacy reassurance card (lock icon + "كل شيء يبقى على جهازك"). Primary button "لنبدأ" (full-width, 58px, radius 18, `#1B4D3E`).
- **Action:** button → `habit`.

### 2. Habit picker (`habit`)
- **Purpose:** Choose what to quit.
- **Layout:** Back button (38px white rounded square) + 3-step progress bar (step 1 of 3 filled). Title "ما الذي تريد الإقلاع عنه؟" (25px / 800). Scrollable list of 7 option buttons, each: 44px icon tile (`#EAF0EA`), right-aligned label (16px / 700), and a green check circle when selected. Selected = bg `#EFF4EF`, border `#1B4D3E`; unselected = bg `#FFFFFF`, border `#E7E2D6`. Sticky bottom "متابعة" button.
- **Options & ids:** cannabis القنّب/الحشيش, alcohol الكحول, cigarettes التدخين/السجائر, vaping التدخين الإلكتروني, gambling القمار, porn الإباحية, other عادة أخرى. Each has a custom inline SVG icon.
- **Action:** select sets `habitId`; "متابعة" → `date`.

### 3. Quit date (`date`)
- **Purpose:** Start today or back-date the quit.
- **Layout:** Progress step 2 of 3. Title "متى بدأت رحلتك؟". Two large option cards: "أبدأ اليوم" (today) and "أقلعت منذ مدة" (past). When `past` selected, a **calendar card** appears (mock May/مايو 2026 month grid, day 18 highlighted, footer "33 يومًا حتى اليوم"). Bottom "متابعة".
- **Logic:** `dateChoice` = `today` | `past`. On finish, `today` → days = 1; `past` → days = 33 (demo value). `showCal = dateChoice === 'past'`.
- **Action:** "متابعة" → `spend`.

### 4. Spend setup (`spend`)
- **Purpose:** Optional cost / time / usage inputs that power the savings stats. Fully skippable.
- **Layout:** Progress step 3 of 3. Title "كم كنت تنفق؟". Three white cards, each with a header + iOS-style toggle switch (track `#1B4D3E` on / `#D8D2C2` off, 23px knob translateX 21px):
  - **Cost card** (`costOn`): period chips يومي/أسبوعي/بالساعة/لكل لفافة|قنينة (`costPeriod`: daily/weekly/hourly/perUse) + −/+ stepper (`costAmount`, step 5, currency د.ل). Off → "لن نعرض المال الموفّر."
  - **Time card** (`timeSetupOn`): −/+ stepper (`timeAmount`, minutes, step 5, min 5).
  - **Usage card** (`usageOn`): method chips لفافة/بونغ/فيب/أخرى (`usageMethod`) + −/+ stepper (`usageAmount`, 1–20, مرّات/يوم).
  - When `costOn`, a green info pill estimates monthly savings ("ستوفّر نحو {monthly} د.ل شهريًا").
- **Actions:** "إنهاء الإعداد" and "تخطّي هذه الخطوة" both → `finish()` → `home`.

### 5. Home dashboard (`home`)
- **Purpose:** Main hub.
- **Layout (top→bottom):**
  - Header: brand mark (`assets/sanad-mark.png`, 25px tall) + settings gear button → `relapse`.
  - Greeting "مساؤك طيّب" + "إقلاعك عن {habitName}".
  - **Hero "sober clock"** card: dark green gradient (`hero1`→`hero2`), radius 30, big circular SVG progress ring (r=100, gradient stroke `#C7D6C5→#8FAF98`, dashoffset from day progress toward next milestone), large day number (78px), live HH:MM:SS counter (LTR, tabular), and "المعلم القادم — باقٍ N يومًا لـ {next}".
  - **Pledge toggle button** "أتعهّد بالبقاء نظيفًا اليوم" → checked state fills green.
  - **Check-in CTA** card → `checkin`.
  - **Stats grid** (2×2 white cards): المال الموفّر (د.ل), الوقت المستعاد (ساعة), أطول سلسلة (يوم), مرّات تجنّبتها. Each shows `—` if its toggle was turned off in setup.
  - **"مسار تعافيك" banner** → `health`.
  - Milestones strip and a bottom nav (home / progress).
- **Computed stats** (see State / Derived below): money, timeH, units, longest, next milestone.

### 6. Check-in (`checkin`)
- **Purpose:** Log mood + craving for the day.
- **Layout:** 5-point **mood** selector (`mood` 0–4, selected fills `#1B4D3E`) and a 5-step **craving** scale (`craving` 0–4, fills up to selection, color warms `#8FAF98 → #C26F3C`, labels لا رغبة … رغبة شديدة).

### 7. Health / recovery timeline (`health`)
- **Purpose:** "What's healing now" — 13 body/mind recovery metrics, each a semicircular gauge.
- **Layout:** Phase header (phaseName by days). Grid of metric cards built from `metricsDef` (13 entries: appetite, heart, mood, energy, detox, focus, sleep, skin, body, memory, breath, balance, immunity). Each metric has: Arabic name, color, tint, a `full` day count (days to full recovery: 14…120), and three narrative strings (done / now / coming). Gauge fill = `min(100, days/full*100)`. Cards **sort by remaining days ascending**; a summary counts fully-healed metrics. Tapping a card opens the **detail sheet**.
- **Detail sheet** (`detailOpen`): a recovery-curve chart for the selected metric (`detailMetric`) — recovery curve + symptom-intensity curve over 60 days, a "you are here" marker at current day, x-axis ticks, and 4 phase explainer blocks. **Important RTL detail:** the time axis runs **right→left** (`px = PADX + (1 - t/60) * innerW`) so البداية (start) sits on the right and شهران (2 months) on the left, matching the curve direction. Ticks: البداية, أسبوعان, شهر, 6 أسابيع, شهران.

### 8. Achievement / Share card (30-day milestone)
- **Purpose:** Celebrate 30 clean days and share a card — **with selective disclosure.**
- **Layout:** A celebratory card "30 يومًا نظيفًا" (with 🌿 + sparkle animation when `celebrate` prop = lively, plain when quiet), subtitle line, and a row of **toggle chips** that add/remove what appears on the shareable card. Each chip uses `mkTg(on)` styling: on = `#1B4D3E` bg / white / "✓", off = `#ECE7DA` / `#8A9185` / "＋".
- **Disclosure toggles (all independent):**
  - `showMoney` — المال الموفّر
  - `showTime` — الوقت المستعاد / "الوقت"
  - `showUnits` — مرّات تجنّبتها
  - `showMass` — mass avoided (grams/liters/packs — only when the habit has a `massPer`)
  - `showHabit` — **نوع الإدمان (drug/habit type).** When OFF, the subtitle reads just "يومًا نظيفًا" instead of "يومًا نظيفًا من {habit}". This lets a user share their numbers without revealing what they're recovering from. (Added per user request.)
- The share sheet itself (`shareOpen`) overlays the card; `saveImg` marks it saved.

### 9. Relapse / reset (`relapse` → `relapseDone`)
- **Purpose:** Compassionate reset, not failure.
- **Logic:** `doRelapse()` records `longest = max(longest, days)`, sets `days = 0`, screen → `relapseDone`. `restart()` → home with days = 1.

## Interactions & Behavior
- **Navigation** is `go(screen)` which also closes any open detail/share sheet. All buttons are simple onClick handlers (listed at the bottom of the logic class).
- **Live timer:** `setInterval` every 1000ms updates `now`, which redraws the HH:MM:SS within-day clock on home. Clean up the interval on unmount.
- **Toggles/steppers** are immediate optimistic state updates; stats recompute in the render pass.
- **Animations** (CSS keyframes in the prototype — reproduce with the platform's animation API):
  - `breathe` / `breatheGlow` — slow scale + opacity pulse (sober-clock glow).
  - `cardIn` — scale 0.9→1 + fade (card entrance).
  - `floatUp` — translateY 14px→0 + fade.
  - `sparkle` — particles rising 120px + fade (celebration).
  - `sheetUp` — translateY 100%→0 (bottom sheets).
- **RTL:** entire app mirrored; chevrons that point "forward" use `transform: scaleX(-1)`.

## State Management
All state lives in one component (`state` object). Variables:
- `screen` — current view (welcome/habit/date/spend/home/checkin/health/relapse/relapseDone).
- `habitId` — selected habit.
- `days`, `longest` — clean-day count and best streak.
- `mood` (0–4), `craving` (0–4), `pledged` (bool).
- `now` — timestamp, ticked every second.
- `dateChoice` (today/past).
- Setup: `costOn`, `costPeriod`, `costAmount`; `timeSetupOn`, `timeAmount`; `usageOn`, `usageMethod`, `usageAmount`.
- Share disclosure: `showMoney`, `showTime`, `showUnits`, `showMass`, `showHabit`.
- Health: `healthMetric` (selected), `detailOpen`, `detailMetric`.
- Share: `shareOpen`, `imgSaved`.

### Derived values (computed each render — see `renderVals()`)
- `next` = next milestone in `[7, 30, 100, 365]`; ring progress = `days/next`.
- `dailyCost` from period+amount; `money = round(dailyCost * days)`; `monthly = round(dailyCost * 30)`.
- `timeH = round(timeAmount * usageAmount * days / 60)` when time on.
- `units = days * usageAmount` when usage on.
- Stats show `—` when their source toggle is off.
- Health gauges: per metric `value = min(100, round(days/full*100))`, remaining days, done flag, semicircle arc path.
- Achievement (30-day): `mUnits = perDay*30`, `mMoney`, `mTime`, `massVal` from per-habit `massPer`.
- `cleanLine` = `showHabit ? 'يومًا نظيفًا من ' + habitName : 'يومًا نظيفًا'`.

**Data persistence:** the real app should persist all of this **locally on-device only** (e.g. AsyncStorage / UserDefaults / SQLite) — never to a server, per the privacy promise.

## Design Tokens

### Theme (tweakable in prototype via props — bake the defaults unless theming is a feature)
- **mood/primary palette** (default `forest`): primary `#1B4D3E`, hero gradient `#235C49 → #143A2F`, page `#F3F0E8`. Alternates: `sage` (primary `#3F7A60`), `dusk` (primary `#205545`).
- **support/SOS accent** (default `amber`): `#D08A4E → #C26F3C`. Alternates: `clay` `#C56A55→#A8513C`, `calm` `#5E9C72→#467C58`.
- **celebrate**: `lively` (sparkles + 🌿) | `quiet`.

### Colors
- Primary green `#1B4D3E`; deep heading `#16352B`; hero greens `#235C49`, `#143A2F`.
- Page bg `#F3F0E8`; welcome gradient `#E7E2D5 → #DCD6C7`; card white `#FFFFFF`.
- Selected tint `#EFF4EF`; icon tile `#EAF0EA`; soft card grad `#EFF4EF → #E6EEE6`.
- Text: secondary `#8A9185`, muted `#B3B0A4` / `#C3C0B4`, body `#5A6359`.
- Borders: default `#E7E2D6`, toggle-off track `#D8D2C2`.
- Success/accent green `#517F5C`; ring gradient `#C7D6C5 → #8FAF98`.
- Craving scale: `#8FAF98, #B8C58A, #D8C06A, #D89A4E, #C26F3C`.
- SOS/warm: `#C26F3C`, `#C28A3E`, `#D08A4E`.

### Typography
- Family: **Cairo** (Google Fonts), weights 400/500/600/700/800/900.
- Scale (px): hero day number 78; screen titles 25–29 / 800; stat numbers 26 / 800; section headings 15–18 / 700–800; body 13–16 / 500–700; captions/labels 11–13 / 600.
- Numerals: **always Western 1234.**

### Radii
- Buttons / primary CTAs 18; cards 20; hero 30; logo card 30; icon tiles 12–14; chips 12–13; pills 16–20; small squares 12.

### Shadows
- Card: `0 6–8px 16–24px rgba(27,77,62,0.04–0.10)`.
- Hero: `0 22px 44px rgba(20,58,47,0.32)`.
- CTA: `0 12px 26px rgba(27,77,62,0.28)`.
- Logo card: `0 22px 48px rgba(27,77,62,0.14)`.

### Spacing
- Screen horizontal padding 26px (home 18px); cards 18–20px internal; gaps 11–14px between cards; primary buttons 56–58px tall; icon tiles/steppers 44–46px; toggle hit targets ≥ 44px.

## Assets
In `assets/` (and duplicated in `sanad/brand/`):
- `sanad-logo.png` — full lockup, used on welcome.
- `sanad-mark.png` — small wordmark/mark, used in home header.
- `sanad-mark-light.png` — light version for dark backgrounds.
All other graphics (habit icons, gauges, ring, charts, switches) are **inline SVG / CSS drawn in the HTML** — reproduce them as vector components. No raster icon assets needed.

`ios-frame.jsx` is only a preview device bezel — **ignore it** when rebuilding.

## Files
- `Sanad Prototype.dc.html` — the full prototype: all screens (template) + all logic/derived values (the `<script>` `Component` class at the bottom). This is the single source of truth for layout, copy, colors, and behavior.
- `support.js` — the in-house `.dc.html` runtime. **Reference only — do not port.** It explains `<sc-if>`, `{{ }}`, and how `renderVals()` feeds the template.
- `assets/` — logo/mark images.
- `ios-frame.jsx` — preview-only device frame; ignore.

### How to read the prototype
1. Open `Sanad Prototype.dc.html`. The top (template) is the markup per screen, wrapped in `<sc-if value="{{ isX }}">` blocks — one per screen.
2. The bottom `<script>` `class Component` holds `state` (initial values) and `renderVals()` (every computed value + every handler). To understand any `{{ token }}` in the markup, find the same key in the object `renderVals()` returns.
3. `<sc-if value="{{ cond }}">` = render-if; `<sc-for list>` = list map; `{{ a.b }}` = value interpolation (dotted path only).
