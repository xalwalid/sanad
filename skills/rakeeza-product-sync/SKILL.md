---
name: rakeeza-product-sync
description: >-
  Reconcile a Rakeeza product's foundation docs with a new direction or decision,
  then update them cleanly. Use whenever a product's plan changes (stack pivot,
  scope change, new constraint, brand update) and the CHARTER.md / ARCHITECTURE.md
  need to catch up — or whenever starting a session on a product and you want to
  re-ground in its current truth before working. Triggers: "we're pivoting...",
  "update the charter/architecture", "this changes the plan", "sync the docs",
  "what's the current direction for <product>".
metadata:
  type: workflow
  owner: Hussin / Rakeeza
---

# Rakeeza Product Sync

A repeatable workflow for keeping a Rakeeza product's foundation documents
(`CHARTER.md`, `ARCHITECTURE.md`) honest and current when its direction changes.
The goal: the docs should always describe what we're *actually* building, with a
clear trail of why it changed. No silent contradictions, no stale plans.

## When to use

- A product's direction just shifted (stack pivot, MVP rescope, new constraint,
  brand change, phase reorder).
- Starting work on a product and you want to re-ground in its current state.
- A decision was made in chat that isn't yet written down anywhere durable.

## Inputs to gather first (always, before writing anything)

1. **Read the product's existing docs** in its folder — `CHARTER.md`,
   `ARCHITECTURE.md`, and any `/brand` assets.
2. **Read recent context** — relevant prior session transcripts and the project
   memory file, to understand what was already decided and why.
3. **Look at the assets** — logos/mockups in the folder (read images, don't
   assume). Note brand palette, typeface, naming.
4. **Capture the new direction** — exactly what the user is now saying, in their
   words, before interpreting it.

## The core move: reconcile, don't overwrite blindly

Compare the new direction against what the docs currently commit to, and
**explicitly surface every contradiction** before changing anything. For each
conflict, state: what the doc says now, what the new direction says, and which
wins. Recovery-style example to imitate:

> "The doc commits to PWA-first with online community in v1. The new direction is
> native offline-first with community deferred. That's a real pivot — here's what
> it changes: stack, growth loop, and the safety burden."

Never let the new and old plans both sit in the docs as if both are true.

## What to produce

1. **A short reconciliation summary** to the user — the tensions found and how
   each resolves. Flag second-order effects the user may not have noticed (e.g.
   "going native breaks the web-link growth loop — here's the fix").
2. **Updated `CHARTER.md`** — the one-paragraph "what this is", current status,
   phases, product-specific rules, brand, assets in hand, and a dated
   **decisions log** entry for the change.
3. **Updated `ARCHITECTURE.md`** — a "what changed" note at the top, the revised
   stack/data-model/phases/growth-loop, and the same dated decisions-log entry.
   Keep the superseded plan only as a one-line historical note, never as live
   guidance.
4. **Update the project memory file** with the pivot and any new assets/infra.

## Rakeeza house rules to honor in every sync

- Deploy off-laptop only (git push + CI), never from the local machine.
- Built-in growth loop (shareable cards/links) in every product.
- Isolated database per product; high-sensitivity data never co-mingled.
- Design language: modern, minimal, optimistic, human — no clinical aesthetics.
- Each product themes the shared toolkit in its own brand (e.g. Sanad = green,
  Rakeeza core = navy).

## Finish with

- A consistency check: grep the docs for leftover mentions of the superseded plan
  and confirm none remain as live guidance.
- A dated decisions-log line in **both** docs so the change is auditable.
- One concrete next step offered to the user (e.g. "spec the first phase").
