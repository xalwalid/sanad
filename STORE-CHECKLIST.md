# Sanad — Store submission checklist (living doc)

Track everything Google Play + Apple App Store will ask for, and what we still owe them. Legend: done / in progress / not started / needs Hussin.

> Sanad is a **recovery / addiction-support** app. Both stores treat this category with extra scrutiny. Two rules keep us safe: (1) **never make medical claims** — we're a supportive tool, not treatment/diagnosis, and (2) **always surface crisis resources** (Crisis screen + SOS).

## A. Build & technical (automated by our CI)
| Item | Status | Notes |
|---|---|---|
| Android release APK builds | done | CI build-android -> installable APK each push |
| Android App Bundle (.aab) | done | CI produces sanad-android-aab (Play requires .aab) |
| iOS compiles | done | CI build-ios (unsigned). App Store needs signing (below) |
| App icon + splash | done | Generated from Sanad logo in CI |
| applicationId / bundle id | done | ly.com.sanad |
| Version + build number | in progress | 0.1.0+1 in pubspec — bump per release |
| Offline, no data leaves device | done | Phase 1 fully on-device |
| Target SDK / API level | not started | Verify Play's current min target API at submission |

## B. Google Play — listing & policy
| Item | Status | Notes |
|---|---|---|
| Developer account | done | Owned (Hussin) |
| Title / descriptions (EN + AR) | not started | Draft from CHARTER; bilingual |
| Feature graphic 1024x500 | not started | Brand asset to design |
| Phone screenshots (min 2) | not started | Home, Recovery, Progress, Share |
| App icon 512x512 | done | Have the logo source |
| Content rating (IARC) | needs Hussin | Drugs/alcohol refs — answer: educational/supportive, no glorification |
| Data safety form | in progress | Phase 1 shares nothing off-device -> "no data collected" |
| Privacy policy URL | needs Hussin | REQUIRED. Host at sanad.com.ly/privacy |
| Target audience / age | needs Hussin | Adults; not for children |
| Ads declaration | done | No ads |

## C. Apple App Store — listing & review
| Item | Status | Notes |
|---|---|---|
| Developer account | done | Owned (Hussin) |
| Signing: certs + provisioning | not started | Needed for TestFlight/App Store |
| Name/subtitle/keywords (EN+AR) | not started | Bilingual |
| Screenshots per device size | not started | iPhone sizes required |
| Privacy policy URL | needs Hussin | Same sanad.com.ly/privacy |
| App Privacy label | in progress | No data collected in Phase 1 |
| Age rating | needs Hussin | Likely 17+ (alcohol/drugs/gambling) |
| Info.plist usage strings | in progress | Add NSPhotoLibraryAddUsageDescription for "save card to gallery" before iOS release |
| Guideline 5.1 (health) | in progress | No medical claims; supportive framing |

## D. Cross-cutting / legal
| Item | Status | Notes |
|---|---|---|
| Privacy policy | needs Hussin | HARD BLOCKER for both stores. I can draft it |
| Terms of use | not started | Needed before community (Phase 3) |
| "Not medical advice" disclaimer | done | In recovery content + crisis screen |
| Crisis resources localized | in progress | General list now; localize before wide release |
| Account deletion | n/a now | No accounts in Phase 1; required at Phase 3 |

## Immediate needs from Hussin
1. **Privacy policy** — the one hard blocker for both stores. Decide to host at sanad.com.ly/privacy (I can write it).
2. Confirm **age rating** intent (17+ is the safe default).
3. Decide target **launch market(s)** — affects localization + rating.
