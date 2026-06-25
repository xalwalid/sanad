# Sanad — Phase 1 PRD: Offline Recovery Tracker

*Product: Sanad (سند), a Rakeeza product · Owner: Hussin Alwalid · Date: 2026-06-14 · Status: draft for build*
*Stack: Flutter (Android + iOS) · Scope: on-device, offline-first, no accounts*

---

## Problem Statement

People trying to quit a harmful habit (cannabis, alcohol, cigarettes, vaping, gambling, porn) want to see their progress and stay motivated, but the tools that exist make them pay an upfront privacy cost: create an account, admit a stigmatized problem, and hand personal data to a server before getting any value. That first-30-seconds barrier turns away exactly the people who most need a low-friction start. Sanad's Phase 1 removes the barrier entirely — a beautiful, encouraging tracker that runs fully on the user's phone, with no signup and nothing leaving the device — and uses shareable milestone cards as the growth engine for the community that comes later.

## Goals

1. **Deliver value with zero friction** — a user can go from app-open to a live "Day 1" counter in under 60 seconds, with no account and no network.
2. **Sustain motivation** — give users a reason to reopen the app daily (streak, check-in, money/time saved, upcoming milestone).
3. **Drive the growth loop** — make milestone cards beautiful and effortless to share, so each milestone is a marketing moment pointing back to Sanad.
4. **Earn trust through privacy** — the offline promise is real and visible; users feel safe enough to track a stigmatized habit.
5. **Ship fast and safely** — launch on both stores with near-zero operational and legal risk (no user data on our servers, no moderation burden).

## Non-Goals

1. **No community, posts, or social features** — that's Phase 3; building it now adds moderation, safety, and legal burden that would block a fast launch.
2. **No accounts, login, or cloud sync** — the offline promise is the product; the only backup is an optional, identity-free export code.
3. **No medical, therapy, diagnostic, or treatment features** — Sanad is a supportive tool, not a clinical service; medical framing is off-brand and out of scope.
4. **No server backend in Phase 1** — sanad.com.ly + Hetzner are Phase 2; Phase 1 makes zero network calls for core function.
5. **No user-created categories/sub-groups** — fixed habit categories only; Reddit-style sub-groups wait until moderation tooling exists (Phase 3).

## User Stories

**New user (onboarding)**
- As someone quitting a habit, I want to start tracking in seconds without an account, so that I can begin before I talk myself out of it.
- As a new user, I want to pick my habit and set the day I quit (today or a past date), so that my counter reflects reality.
- As a new user, I want to optionally enter how much I used to spend and how much time it took, so that the app can show me money and time saved.
- As a privacy-conscious user, I want clear assurance that my data stays on my phone, so that I trust the app with something stigmatized.

**Returning user (daily loop)**
- As a returning user, I want to see my days clean, money saved, and time reclaimed at a glance, so that I feel my progress.
- As a returning user, I want to log my mood and craving level quickly, so that I stay engaged and can see patterns.
- As a returning user, I want to know what to expect this week for my specific habit, so that I feel understood and prepared.
- As a returning user, I want to see my next milestone approaching, so that I have something to push toward.

**Milestone & sharing**
- As a user hitting 7/30/100 days, I want the app to celebrate with a beautiful card, so that the moment feels earned.
- As a proud user, I want to share my card to WhatsApp/Instagram/Facebook with what I choose to reveal, so that I can inspire others without exposing private details.

**Relapse**
- As a user who relapsed, I want the app to encourage me rather than shame me, so that I keep going.
- As a user who relapsed, I want my longest streak and history preserved, so that I don't feel I lost everything.

**Safety & data**
- As a user in distress, I want quick access to help resources, so that I'm not alone in a hard moment.
- As a user, I want to back up and restore my progress without an account, so that a new phone doesn't erase my streak.

## Requirements

### Must-Have (P0) — the feature isn't viable without these

**Onboarding & setup**
- Pick a habit category from a fixed list (cannabis, alcohol, cigarettes, vaping, gambling, porn, "other").
- Set quit date (default today; allow a past date).
- Optional: spend amount + period (e.g. $/day) and time-per-use, used to compute savings.
- Select country → sets currency for savings display.
- Choose language (English / Arabic) with full RTL support.
- Acceptance: Given a first-time user, when they complete onboarding, then a live Day-N home screen appears, with no account and no network request made.

**Home screen (the daily hook)**
- Live counters: days clean, money saved, time reclaimed — computed from quit date, never stored stale.
- Strong visual progress indicator and the next milestone with countdown.
- Distinct states for day 1, mid-streak (e.g. day 33), and just-after-milestone.
- Acceptance: Given a quit date N days ago with a known spend rate, when the home screen loads, then days = today − quit_date and money = days × daily_spend, displayed in the user's currency.

**Daily check-in**
- Quick log: mood + craving level (+ optional short note).
- Acceptance: Given a user opens check-in, when they pick a mood and craving level and save, then it's stored locally and reflected in their history.

**"What to expect this week" content**
- Per-category, time-phased guidance bundled in the app, available offline.
- Original copy (structure may be informed by established quit communities, but not copied).
- Acceptance: Given a cannabis user on day 10, when they open guidance, then they see content relevant to that week for cannabis.

**Milestone cards**
- Auto-celebrate at 7 / 30 / 100 days (extensible to more).
- Generate a shareable image card; user controls what's shown (days only, or days + money/time).
- Native share sheet to WhatsApp / Instagram / Facebook / etc.
- Acceptance: Given a user reaches day 7, when the milestone triggers, then a card is generated and can be shared via the OS share sheet; the user can toggle which stats appear before sharing.

**Relapse flow**
- One-tap "I relapsed" that resets current streak but **preserves longest streak + full history**; responds with encouragement, never shame.
- Acceptance: Given a current streak of 40 and longest of 40, when the user logs a relapse, then current resets to 0, longest stays 40, history is intact, and the UI shows an encouraging message.

**Crisis-resources screen**
- Always-accessible "you're not alone" panel with help resources. No diagnosis, no shaming.
- Acceptance: Given any screen, when the user opens help, then crisis resources are shown (works offline).

**Backup / restore (identity-free)**
- User-initiated export to a restore code/file and restore on another device; tied to no identity, no server.
- Acceptance: Given a user with data, when they export and then restore on a fresh install, then streak, history, and settings are recovered.

**Privacy guarantee (visible)**
- Clear in-app statement that all data stays on the device; no analytics that transmit personal recovery data.
- Acceptance: Given onboarding, when the user reaches the privacy note, then the offline promise is stated plainly before any data is entered.

### Nice-to-Have (P1) — fast follow

- Local notifications: daily check-in reminder, milestone celebration, "almost at next milestone."
- History/insights view: mood + craving trends over time (on-device charts).
- Multiple simultaneous habits tracked separately.
- Customizable milestone set and personal milestones (e.g. "my birthday clean").
- Theming polish, card template variety, light/dark within the green identity.
- More languages beyond EN/AR (architecture already supports it).

### Future Considerations (P2) — design for, don't build now

- Optional anonymous cloud backup (random key, no identity) — design backup format so this is addable.
- Account creation that *links* an existing offline profile into the Phase-3 community without losing local history.
- Card pages resolving on sanad.com.ly (Phase 2) — design card metadata so a web page can render the same card.
- Crisis-signal detection from check-in patterns surfacing the help panel proactively (handle sensitively).

## Success Metrics

**Leading indicators (days–weeks)**
- **Activation:** % of installs that complete onboarding and reach the home screen. Target ≥ 80%.
- **Time to first value:** median app-open → live counter < 60s.
- **D1 / D7 retention:** % returning next day / within 7 days. Target D7 ≥ 30% (strong for a habit tracker).
- **Check-in rate:** % of active users logging a check-in at least 3×/week.
- **Card share rate:** % of users reaching a milestone who share the card. Target ≥ 25%.

**Lagging indicators (weeks–months)**
- **Milestone reach:** % of activated users hitting day 7 / 30 / 100.
- **Install→install loop:** installs attributable to shared cards (measurable once Phase 2 card pages exist).
- **Retention at 30 days:** % still opening the app at day 30.
- **Store rating / qualitative sentiment** on both stores.

*Measurement note:* Phase 1 is offline, so metrics rely on privacy-respecting, non-identifying aggregate telemetry only (or store-provided analytics). No recovery content is ever transmitted. Decide the exact telemetry approach before build (see Open Questions).

## Open Questions

- **Telemetry approach** *(data/eng)* — how do we measure activation/retention without breaking the offline promise? (Privacy-preserving aggregate events vs. store analytics only.) **Blocking** for metrics, not for build.
- **Per-week content sourcing** *(Hussin/content)* — which sources do we model structure on (r/leaves, r/stopdrinking, NHS/CDC timelines) before writing original copy? **Blocking** for the content feature.
- **Crisis resources** *(Hussin/legal)* — global product: do we ship a curated international resource list, or detect country and localize? What's the legally safe framing? **Blocking** for the crisis screen.
- **Backup format** *(eng)* — plain export file vs. short restore code; encryption at rest? Decide so P2 cloud backup stays compatible.
- **Local DB** *(eng)* — Drift/SQLite vs Isar. Non-blocking; decide at scaffold.
- **Monetization** *(Hussin)* — free / donations / later paid tier? Doesn't affect Phase 1 features but needed before store listings.

## Timeline Considerations

- **Dependencies:** developer accounts (✅ owned), brand assets (✅ in `/brand`), green Flutter theme + i18n skeleton (build at scaffold). No server dependency — Phase 1 ships independent of Hetzner/sanad.com.ly.
- **Suggested phasing within Phase 1:**
  1. Scaffold: Flutter project, green theme, i18n (EN/AR + RTL), local DB, off-laptop CI for both stores.
  2. Core loop: onboarding → home counters → check-in → relapse.
  3. Motivation: milestone cards + share, "what to expect this week" content.
  4. Trust & safety: privacy guarantee, crisis screen, backup/restore.
  5. Store submission (both stores), then P1 fast-follows.
- **Growth-loop note:** card *sharing* works in Phase 1 (image share), but cards resolving to a web page is Phase 2 — design card metadata now so Phase 2 is drop-in.

---

*Related docs: `CHARTER.md`, `ARCHITECTURE.md` (this folder).*
