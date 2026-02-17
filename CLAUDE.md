# Wiom Partner App — Flutter

## Project Objective

Build a production-ready Android app that replicates the **Wiom Partner App PayG Compliance Quiz** prototype. The app ensures Wiom field partners understand and acknowledge the new PayG (Pay-As-You-Go) payment model rules before they can proceed with their work. Partners must pass an 11-question Hindi-language quiz to unlock access, enforcing compliance through a mandatory knowledge check.

## Project Status

- **v1.0 — COMPLETE** (built 2026-02-17)
- Release APK: `build/app/outputs/flutter-apk/app-release.apk` (42MB)
- All 4 screens implemented, quiz logic working, persistent state via SharedPreferences

## Target Platform

- **Android only** (scaffolded with `--platforms android`)
- Package name: `com.wiom.wiom_partner_app`
- Min SDK: 21 (Android 5.0+)

## Origin

- **Prototype repo:** https://github.com/dxm-wiom/PartnerApp (HTML/CSS/JS)
- This Flutter project is a pixel-accurate native recreation of that prototype

---

## Functionality

### User Flow

1. **App Launch** — Checks SharedPreferences for `wiom_quiz_passed`
   - If `true` → Show home dashboard only (no modal)
   - If `false` → Show home dashboard + quiz modal overlay

2. **Intro Screen** (inside modal) — Explains the new PayG rule and prompts quiz start

3. **Quiz Flow** (inside same modal) — 11 sequential multiple-choice questions
   - Correct answer → feedback shown → "Next" button → advance
   - Wrong answer → feedback shown → "Restart" button + toast → reset to Q1
   - One wrong = full restart, no partial progress saved
   - Must answer all 11 correctly in a single run

4. **Success Screen** (inside same modal) — Shows PayG Certified badge, payout info
   - Saves `wiom_quiz_passed = true` to SharedPreferences
   - "Continue" button dismisses the modal permanently

5. **Home Dashboard** — Static decorative screen visible behind modal (simulates real partner app)

### Business Rules

1. One wrong answer = full restart (no partial progress)
2. Must answer all 11 questions correctly in sequence to pass
3. No skipping, no going back to previous questions
4. Feedback (correct/wrong + explanation) shown after every answer
5. Quiz passed state is persistent — once passed, modal never reappears
6. Options are disabled after selection — no changing answers
7. No network calls — everything is local and hardcoded

---

## Architecture

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.41.1 (Dart 3.11.0) |
| State management | `setState` (simple widget-level state) |
| Persistence | `shared_preferences` ^2.2.0 |
| UI approach | Material 3, custom widgets, no third-party UI libraries |
| Fonts | System default (Roboto on Android) |

### State Machine

```
INTRO → QUIZ → SUCCESS → DISMISSED
         ↑         |
         └─────────┘ (wrong answer restarts quiz, stays in QUIZ state)
```

State is managed in `QuizModal` via a `QuizState` enum. Quiz question index and answer state are managed in `QuizStep` via `QuizStepState`.

### File Structure

```
lib/
├── main.dart                    # App entry, MaterialApp, theme, system UI config
├── theme/
│   ├── colors.dart              # WiomColors — all brand/semantic color constants
│   └── text_styles.dart         # WiomTextStyles — all text style constants
├── models/
│   └── quiz_question.dart       # QuizQuestion data class
├── data/
│   └── quiz_data.dart           # defaultQuizData — all 11 questions hardcoded
├── screens/
│   └── home_screen.dart         # Root screen — Stack of dashboard + modal + toast
├── widgets/
│   ├── home_dashboard.dart      # Static dashboard (header, tabs, booking card, stats)
│   ├── quiz_modal.dart          # Modal overlay — manages intro/quiz/success steps
│   ├── intro_step.dart          # Intro content (title, body, CTA)
│   ├── quiz_step.dart           # Quiz flow (progress bar, question, options, feedback)
│   ├── success_step.dart        # Success screen (badge, payout chip, note, CTA)
│   ├── option_card.dart         # Single quiz option (A/B/C/D) with state variants
│   └── restart_toast.dart       # Slide-in toast for wrong answer restart
└── services/
    └── storage_service.dart     # SharedPreferences wrapper (isQuizPassed / setQuizPassed)
```

### Key Architectural Decisions

1. **Modal is a Stack overlay, not a route** — `HomeScreen` uses a `Stack` with `HomeDashboard` at the base, `QuizModal` on top (with scrim), and `RestartToast` at the highest z-index
2. **Modal has internal steps** — `QuizModal` uses a `QuizState` enum to switch between `IntroStep`, `QuizStep`, and `SuccessStep` within the same container
3. **Quiz restart doesn't close modal** — `QuizStepState.resetQuiz()` resets to Q0 in-place
4. **No state management library** — App is simple enough for `setState`; no Provider/Riverpod/Bloc needed

---

## Design System

### Colors (from `lib/theme/colors.dart`)

| Token | Hex | Usage |
|-------|-----|-------|
| brand600 | #D9008D | Primary CTA, active tab, progress bar |
| brand300 | #FFB2E4 | Booking card border, dashed badge ring |
| brand100 | #FFE5F6 | Booking card background |
| secondary | #443152 | Header bar background |
| positive600 | #008043 | Correct answer, success elements |
| negative600 | #E01E00 | Wrong answer, error elements |
| info600 | #6D17CE | Badge gradient start |
| neutral900 | #161021 | Titles, primary text |
| neutral700 | #665E75 | Body text |
| neutral200 | #E8E4F0 | Borders, dividers |
| neutralWhite | #FAF9FC | App background |

### Typography (from `lib/theme/text_styles.dart`)

| Style | Size | Weight | Color |
|-------|------|--------|-------|
| popupTitle | 22px | Bold (700) | neutral900 |
| quizQuestion | 17px | SemiBold (600) | neutral900 |
| homeGreeting | 16px | Medium (500) | white |
| bodyText | 15px | Regular (400) | neutral700 |
| optionText | 14px | Regular (400) | neutral800 |
| quizCounter | 13px | SemiBold (600) | neutral500 |
| feedbackCorrect/Wrong | 13px | Regular (400) | positive600/negative600 |

### Animations

| Animation | Duration | Curve | Details |
|-----------|----------|-------|---------|
| Modal entry | 300ms | easeOut | Scale 0.95→1.0 + opacity 0→1 |
| Restart toast | 300ms | easeOut | Slide in from top, auto-dismiss 2500ms |
| Progress bar | 300ms | ease | Animated width via `AnimatedContainer` |

---

## Quiz Content

11 questions about PayG model rules (all in Hindi). Defined in `lib/data/quiz_data.dart`.

**Answer key (0-indexed):** 2, 0, 2, 1, 1, 2, 1, 2, 2, 2, 1

Topics covered:
1. Recharge flexibility (any number of days)
2. Customer fee (only ₹300 security deposit)
3. No additional payments allowed
4. Cash payment handling (QR/UPI only)
5. Partner payout (₹300 fixed per install)
6. Payout unaffected by customer usage
7. Initial internet duration (2 days)
8. Mandatory installation (can't refuse)
9. No new fees for partners
10. Scenario: refusing extra payment
11. Churn rule change (no more ₹300 on churn)

---

## Persistent Storage

| Key | Type | Purpose |
|-----|------|---------|
| `wiom_quiz_passed` | `bool` | Whether quiz has been completed successfully |

Managed via `StorageService` (`lib/services/storage_service.dart`), wrapping `SharedPreferences`.

---

## Build & Run

### Prerequisites

All installed at `C:\Users\Dhrav Mathur\development\`:
- Flutter SDK 3.41.1
- Microsoft OpenJDK 17.0.14 (aarch64)
- Android SDK 36 (build-tools 34/35/36, NDK 28.2, CMake 3.22.1)

Environment configured in `~/.bashrc`.

### Commands

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Analyze code
flutter analyze
```

---

## Language & Locale

- All user-facing text is in **Hindi** (हिंदी)
- Locale set to `hi` in MaterialApp
- Tone: Casual, warm, positive. No blame tone. Benefit-first, action-later.
- See `design_reference/Wiom_Design_Guidelines_v1.txt` for full UX writing guidelines

---

## Design Reference Files

- `design_reference/style_reference.png` — Visual reference for home screen styling
- `design_reference/popup_reference.png` — Visual reference for modal/popup design
- `design_reference/Wiom_Design_Guidelines_v1.txt` — Full Wiom design system docs

---

## Future Scope (Not Implemented)

- Admin panel / CMS for quiz content editing
- Network-based config fetching
- iOS build support
- Analytics / quiz completion tracking
- Multiple quiz modules beyond PayG compliance
