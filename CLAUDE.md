# Wiom Partner App — Flutter Implementation Spec

## Overview

This is a Flutter mobile app that replicates the **Wiom Partner App PayG Compliance Quiz** prototype. The HTML/CSS/JS prototype is complete and deployed at:

- **Prototype repo:** https://github.com/dxm-wiom/PartnerApp
- **Live prototype (local):** Serve `index.html` from the prototype repo

This Flutter project should produce a pixel-accurate recreation of the prototype, targeting Android (primary) and iOS (secondary). The app is a single-screen experience: a simulated partner dashboard with a modal overlay that guides the partner through a compliance quiz.

---

## Setup Instructions

### 1. Create the Flutter project

```bash
flutter create --org com.wiom --project-name wiom_partner_app .
```

This should be run inside the `PartnerAppFlutter/` directory so it scaffolds into the existing folder (alongside this CLAUDE.md and the design_reference/).

### 2. Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
  google_fonts: ^6.1.0   # Optional — only if system font stack isn't sufficient
```

### 3. Target platforms

- **Primary:** Android (minSdk 21)
- **Secondary:** iOS
- **Not required:** Web, Windows, Linux, macOS

### 4. Run

```bash
flutter run
```

---

## Design Tokens

All values come from the prototype's CSS custom properties and `design_reference/Wiom_Design_Guidelines_v1.txt`.

### Colors

```dart
class WiomColors {
  // Brand
  static const brand600    = Color(0xFFD9008D);
  static const brand300    = Color(0xFFFFB2E4);
  static const brand200    = Color(0xFFFFCCED);
  static const brand100    = Color(0xFFFFE5F6);
  static const secondary   = Color(0xFF443152);

  // Positive (success/correct)
  static const positive600 = Color(0xFF008043);
  static const positive300 = Color(0xFFA5E5C6);
  static const positive100 = Color(0xFFE1FAED);

  // Negative (error/wrong)
  static const negative600 = Color(0xFFE01E00);
  static const negative300 = Color(0xFFFFBDB3);
  static const negative100 = Color(0xFFFFE9E5);

  // Info
  static const info600     = Color(0xFF6D17CE);
  static const info100     = Color(0xFFF1E5FF);

  // Neutral
  static const neutral900  = Color(0xFF161021);
  static const neutral800  = Color(0xFF352D42);
  static const neutral700  = Color(0xFF665E75);
  static const neutral500  = Color(0xFFA7A1B2);
  static const neutral300  = Color(0xFFD7D3E0);
  static const neutral200  = Color(0xFFE8E4F0);
  static const neutral100  = Color(0xFFF1EDF7);
  static const neutralWhite = Color(0xFFFAF9FC);

  // Misc
  static const goldStar    = Color(0xFFF2E983);
  static const modalScrim  = Color(0x80161021); // 50% opacity neutral900
}
```

### Typography

The prototype uses the system font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`. In Flutter, the default `MaterialApp` font (Roboto on Android, SF Pro on iOS) is a good match. No custom font needed.

Key text styles from the prototype:

| Usage | Size | Weight | Color |
|-------|------|--------|-------|
| Popup title / Success title | 22px | 700 (Bold) | neutral900 |
| Quiz question | 17px | 600 (SemiBold) | neutral900 |
| Home greeting | 16px | 500 (Medium) | white |
| Body text / Popup body | 15px | 400 (Regular) | neutral700 |
| Option text | 14px | 400 (Regular) | neutral800 |
| Tab label | 14px | 400/600 | neutral500 / brand600 (active) |
| Quiz counter | 13px | 600 (SemiBold) | neutral500 |
| Feedback text | 13px | 400 | positive600 / negative600 |
| Success note | 13px | 400 | neutral700 |
| Partner icon text | 11px | 600 | white |
| Badge label | 10px | 700 | white |

### Spacing & Layout

- **App max width:** 420px (centered on larger screens). On mobile, full width.
- **Modal max width:** 400px
- **Modal border radius:** 20px
- **Modal min height:** 75% of viewport
- **Modal max height:** 90% of viewport
- **Card border radius:** 16px (booking card), 12px (options, buttons, feedback)
- **Badge border radius:** 10px (rating, success payout, success note)
- **Standard padding:** 20px (home content), 24px horizontal / 28px top / 32px bottom (modal content)
- **Button padding:** 16px vertical (primary), 14px vertical (next/restart)
- **Option card padding:** 14px
- **Option letter circle:** 28px diameter
- **Partner icon:** 40px x 40px, border-radius 10px
- **Success badge:** 100px diameter circle with 8px dashed border ring
- **Progress bar height:** 4px
- **Avatar dots:** 28px diameter, -8px overlap margin

### Animations

- **Modal entry:** Scale from 0.95 to 1.0 + opacity 0 to 1, 300ms ease-out
- **Restart toast:** Slide in from top, 300ms ease, auto-dismiss after 2500ms
- **Progress bar:** Width transition 300ms ease

---

## Screen-by-Screen UI Spec

### Screen 1: Home (Always Visible Behind Modal)

This is a simulated partner dashboard. It's static/decorative — no real functionality.

**Layout (top to bottom):**

1. **Header bar** — `secondary` (#443152) background
   - Left: Partner icon ("P+" in brand600 circle) + greeting text "नमस्ते, रोहित"
   - Right: Rating badge ("★ 4.8" gold text on translucent white bg) + hamburger menu icon "☰"

2. **Tab bar** — Two tabs: "नेटवर्क बढ़ायें" (active, brand600 underline) and "पैसा कमायें" (inactive)

3. **Content area** — White background, 20px padding
   - **Booking card** — brand100 bg, brand300 border, 16px radius
     - Left: Count "08" (48px bold), 4 overlapping avatar dots, label "कस्टमर प्रतीक्षा कर रहे हैं"
     - Right: brand600 circle arrow button "→"
   - **Stats row** — "कुल एक्टिव कस्टमर" label + "276" value, separated by neutral200 border-top

### Screen 2: Intro Modal

Centered floating modal over a scrim (50% opacity neutral900).

**Content:**
- Title: "नया नियम: ₹300 हर नए इंस्टॉल पर!" (22px bold)
- Body: "अब आपको हर **नए सफल इंस्टॉल** पर ₹300 मिलेंगे। इस नियम को चालू करने के लिए एक छोटा सा क्विज़ पूरा करें।" (15px, neutral700). Note: "नए सफल इंस्टॉल" is underlined in brand600.
- CTA button: "क्विज़ शुरू करें" (brand600 bg, white text, full width, 12px radius)

### Screen 3: Quiz (Inside Same Modal)

Replaces intro content within the modal sheet.

**Layout:**
1. **Progress bar** — 4px height at top of modal. Fill color: brand600. Width = `(currentQuestion + 1) / totalQuestions * 100%`

2. **Scrollable content area:**
   - Counter: "1/11" (13px semibold, neutral500)
   - Question text (17px semibold, neutral900)
   - 4 option cards, stacked vertically with 10px gap:
     - Each card: 2px neutral200 border, 12px radius, 14px padding
     - Letter circle (A/B/C/D) + option text
   - Feedback box (hidden until answer selected)
   - Action button (hidden until answer selected)

**Option states:**
- **Default:** neutral200 border, neutral100 letter bg
- **Correct:** positive600 border, positive100 bg, positive600 letter bg (white text)
- **Wrong:** negative600 border, negative100 bg, negative600 letter bg (white text)
- **Disabled:** opacity 0.6 (except the selected correct/wrong card stays opacity 1)

**Feedback box:**
- Correct: positive100 bg, positive300 border, positive600 text, "✓ सही जवाब! {explanation}"
- Wrong: negative100 bg, negative300 border, negative600 text, "✗ गलत जवाब। {explanation}"

**Action buttons:**
- After correct (not last): "अगला सवाल →" (positive600 bg)
- After correct (last question): "पूरा हुआ ✓" (positive600 bg)
- After wrong: "फिर से शुरू करें" (brand600 bg)

### Screen 4: Success (Inside Same Modal)

Replaces quiz content within the modal sheet.

**Layout (centered, column):**
1. **Badge** — 100px circle, gradient bg (info600 → #9B4DFF at 135deg), with outer 8px dashed ring (brand300). Inner content: "PayG" (26px) + "CERTIFIED" (10px bold uppercase), white text.
2. **Title:** "बधाई हो!" (22px bold)
3. **Subtitle:** "आपने PayG सिस्टम की सभी बातें समझ ली हैं। अब आपको हर **नए सफल इंस्टॉल** पर मिलेंगे" (15px, neutral700, max-width 300px)
4. **Payout chip:** "₹300 प्रति नया इंस्टॉल" (20px bold, positive600 text, positive100 bg, positive300 border, 10px radius)
5. **Note box:** "ध्यान दें: पुराना नियम (churned कस्टमर पर ₹300) अब लागू नहीं है। यह पेआउट सिर्फ नए इंस्टॉल पर मिलेगा।" (13px, neutral700, neutral100 bg, neutral300 border, 10px radius, max-width 320px)
6. **CTA:** "आगे बढ़ें" (brand600 bg, full width)

### Restart Toast

Appears at the top of the screen when a wrong answer triggers quiz restart.

- Full width (max 420px), centered horizontally
- negative100 bg, negative300 2px bottom border, negative600 text
- Message: "कोई बात नहीं! चलो फिर से शुरू करते हैं"
- Slides in from top (300ms), auto-dismisses after 2500ms
- z-index above the modal

---

## Quiz Flow — State Machine

```
States: INTRO → QUIZ → SUCCESS → DISMISSED

INTRO:
  on "क्विज़ शुरू करें" tap → QUIZ (currentQuestion = 0)

QUIZ:
  - Render question[currentQuestion]
  - On option tap:
    - if correct AND not last question → show "अगला सवाल" button
      - on tap → currentQuestion++ → re-render
    - if correct AND last question → show "पूरा हुआ" button
      - on tap → SUCCESS
    - if wrong → show "फिर से शुरू करें" button + toast
      - on tap → currentQuestion = 0 → re-render

SUCCESS:
  - Save quiz_passed = true to SharedPreferences
  - on "आगे बढ़ें" tap → DISMISSED (hide modal)

DISMISSED:
  - Modal hidden, home screen visible
  - On next app launch, check SharedPreferences:
    - if quiz_passed → stay DISMISSED (no modal)
    - if not passed → show INTRO
```

### Business Rules

1. **One wrong = full restart.** No partial progress is saved.
2. **Must answer all questions correctly in sequence** to pass.
3. **No skipping, no going back** to previous questions.
4. **Feedback shown after every answer** (correct or wrong + explanation).
5. **Quiz passed state is persistent** — once passed, the modal never reappears.
6. **Options are disabled after selection** — no changing answers.

---

## Data Models

### QuizQuestion

```dart
class QuizQuestion {
  final String question;
  final List<String> options; // Always exactly 4
  final int correct;          // 0-based index of correct option
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
```

### AppConfig

```dart
class AppConfig {
  final IntroConfig intro;
  final List<QuizQuestion> quiz;
  final SuccessConfig success;

  const AppConfig({
    required this.intro,
    required this.quiz,
    required this.success,
  });
}

class IntroConfig {
  final String title;
  final String body;
  final String cta;

  const IntroConfig({
    required this.title,
    required this.body,
    required this.cta,
  });
}

class SuccessConfig {
  final String title;
  final String subtitle;
  final String payout;
  final String note;
  final String cta;

  const SuccessConfig({
    required this.title,
    required this.subtitle,
    required this.payout,
    required this.note,
    required this.cta,
  });
}
```

---

## All 11 Quiz Questions

Answer key: C, A, C, B, B, C, B, C, C, C, B (1-indexed letter) → 0-indexed: 2, 0, 2, 1, 1, 2, 1, 2, 2, 2, 1

```dart
const List<QuizQuestion> defaultQuizData = [
  QuizQuestion(
    question: 'PayG मॉडल में कस्टमर कितने दिन का रिचार्ज कर सकता है?',
    options: ['सिर्फ 30 दिन', 'सिर्फ 7 दिन', 'जितने दिन चाहे (1 दिन, 7 दिन, 28 दिन आदि)', '2 दिन ही'],
    correct: 2,
    explanation: 'PayG में कस्टमर अपनी ज़रूरत के हिसाब से 1, 7, 28 या कितने भी दिन का रिचार्ज कर सकता है।',
  ),
  QuizQuestion(
    question: 'PayG सेटअप में कस्टमर से कितनी फीस ली जाती है?',
    options: ['₹300 सिक्योरिटी फीस', '₹300 + इंस्टॉलेशन फीस', '₹500 एडवांस', '₹300 + रिचार्ज अमाउंट'],
    correct: 0,
    explanation: 'कस्टमर से सिर्फ ₹300 सिक्योरिटी फीस ली जाती है। इसके अलावा कोई और पेमेंट नहीं।',
  ),
  QuizQuestion(
    question: '₹300 सिक्योरिटी फीस के अलावा क्या कोई और पेमेंट लेने की अनुमति है?',
    options: ['हाँ, अगर कस्टमर माने', 'हाँ, इंस्टॉलेशन के समय', 'नहीं, कोई और पेमेंट नहीं', 'पार्टनर की इच्छा पर'],
    correct: 2,
    explanation: '₹300 के अलावा किसी भी तरह का कोई और पेमेंट लेना सख्त मना है।',
  ),
  QuizQuestion(
    question: 'अगर कस्टमर कैश में पेमेंट करना चाहता है तो सही तरीका क्या है?',
    options: ['पार्टनर कैश ले सकता है', 'कस्टमर QR कोड स्कैन करवा कर किसी से UPI पेमेंट करवा सकता है', 'कैश सीधे ऑफिस में जमा करना होगा', 'कैश लेने की अनुमति है'],
    correct: 1,
    explanation: 'पार्टनर कैश नहीं ले सकता। कस्टमर QR स्कैन करवा कर किसी और से UPI पेमेंट करवा सकता है।',
  ),
  QuizQuestion(
    question: 'हर सफल इंस्टॉल पर पार्टनर को कितना मिलता है?',
    options: ['₹200', '₹300', '₹500', 'कस्टमर के रिचार्ज पर निर्भर'],
    correct: 1,
    explanation: 'हर सफल इंस्टॉल पर पार्टनर को ₹300 का फिक्स्ड पेआउट मिलता है।',
  ),
  QuizQuestion(
    question: 'अगर कस्टमर 30 दिन में सिर्फ 1 दिन का रिचार्ज करे तो पार्टनर के ₹300 पर क्या असर होगा?',
    options: ['पार्टनर का पैसा कट जाएगा', 'आधा मिलेगा', 'पूरा ₹300 तय रहेगा', 'कुछ नहीं मिलेगा'],
    correct: 2,
    explanation: 'कस्टमर कितना भी रिचार्ज करे, पार्टनर का ₹300 पेआउट फिक्स्ड है। कोई असर नहीं पड़ता।',
  ),
  QuizQuestion(
    question: 'PayG सेटअप के बाद कस्टमर को कितने दिन का नेट शुरू में मिलता है?',
    options: ['1 दिन', '2 दिन', '7 दिन', '30 दिन'],
    correct: 1,
    explanation: 'सेटअप के बाद कस्टमर को शुरू में 2 दिन का इंटरनेट मिलता है।',
  ),
  QuizQuestion(
    question: 'क्या पार्टनर अपनी मर्जी से किसी कस्टमर का इंस्टॉलेशन मना कर सकता है?',
    options: ['हाँ', 'सिर्फ दूर होने पर', 'नहीं, सिस्टम से आया कनेक्शन लगाना अनिवार्य है', 'अगर कस्टमर कम रिचार्ज करे'],
    correct: 2,
    explanation: 'सिस्टम से असाइन हुआ हर कनेक्शन लगाना अनिवार्य है। मना करना नियम के खिलाफ है।',
  ),
  QuizQuestion(
    question: 'क्या PayG में पार्टनर को कोई नई फीस देनी होती है?',
    options: ['हाँ, जॉइनिंग फीस', 'हाँ, सिक्योरिटी फीस', 'नहीं, कोई नई फीस नहीं', 'हर महीने फीस देनी होती है'],
    correct: 2,
    explanation: 'PayG में पार्टनर को कोई नई फीस नहीं देनी होती। सब कुछ पहले जैसा ही है।',
  ),
  QuizQuestion(
    question: 'इंस्टॉलेशन के समय कस्टमर कहता है:\n"मैं ₹300 के अलावा ₹500 इंस्टॉलेशन के लिए दे देता हूँ, जल्दी लगा दो।"\n\nआप क्या करेंगे?',
    options: ['₹800 लेकर इंस्टॉल कर देंगे', '₹300 लेकर बाकी मना कर देंगे', 'सिर्फ ₹300 सिक्योरिटी फीस ही लेंगे, बाकी लेने की अनुमति नहीं', 'पहले पैसा लेकर बाद में सिस्टम में डाल देंगे'],
    correct: 2,
    explanation: 'सिर्फ ₹300 सिक्योरिटी फीस लेने की अनुमति है। इसके अलावा किसी भी तरह का पेमेंट लेना मना है।',
  ),
  QuizQuestion(
    question: 'पहले नियम में अगर कस्टमर पहले महीने के बाद Wiom छोड़ देता था (churn करता था) तो पार्टनर को ₹300 मिलते थे।\n\nPayG के नए नियम में यह क्या स्थिति है?',
    options: ['वही पुराना नियम लागू रहेगा', 'अब churn पर ₹300 नहीं मिलते', '₹300 दोगुना मिलते हैं', 'कस्टमर पर निर्भर करता है'],
    correct: 1,
    explanation: 'नए PayG नियम में churn पर ₹300 नहीं मिलते। अब पेआउट सिर्फ नए सफल इंस्टॉल पर मिलता है।',
  ),
];
```

---

## Default Config Content

### Intro Screen

```
title: "नया नियम: ₹300 हर नए इंस्टॉल पर!"
body:  "अब आपको हर नए सफल इंस्टॉल पर ₹300 मिलेंगे। इस नियम को चालू करने के लिए एक छोटा सा क्विज़ पूरा करें।"
       (Note: "नए सफल इंस्टॉल" should be underlined with brand600 color)
cta:   "क्विज़ शुरू करें"
```

### Success Screen

```
title:    "बधाई हो!"
subtitle: "आपने PayG सिस्टम की सभी बातें समझ ली हैं। अब आपको हर नए सफल इंस्टॉल पर मिलेंगे"
          (Note: "नए सफल इंस्टॉल" should be bold)
payout:   "₹300 प्रति नया इंस्टॉल"
note:     "ध्यान दें: पुराना नियम (churned कस्टमर पर ₹300) अब लागू नहीं है। यह पेआउट सिर्फ नए इंस्टॉल पर मिलेगा।"
cta:      "आगे बढ़ें"
```

### Restart Toast

```
message: "कोई बात नहीं! चलो फिर से शुरू करते हैं"
```

---

## Persistent Storage (SharedPreferences)

Mapping from the prototype's localStorage to SharedPreferences:

| Prototype (localStorage) | Flutter (SharedPreferences) | Type | Purpose |
|---|---|---|---|
| `wiom_quiz_passed` | `wiom_quiz_passed` | `bool` | Whether quiz has been completed |
| `wiom_config` | Not needed for v1 | — | Admin config overrides (future scope) |

### Usage

```dart
// Check on app start
final prefs = await SharedPreferences.getInstance();
final quizPassed = prefs.getBool('wiom_quiz_passed') ?? false;

// Save after quiz completion
await prefs.setBool('wiom_quiz_passed', true);
```

---

## Admin Panel

**Not in scope for this Flutter build.** The admin panel was a prototype-only tool for stakeholder content editing via localStorage. In the Flutter version, quiz content is hardcoded. A future admin/CMS integration may be added later.

---

## Suggested File Structure

```
lib/
├── main.dart                    # App entry, MaterialApp, theme setup
├── theme/
│   ├── colors.dart              # WiomColors class
│   └── text_styles.dart         # WiomTextStyles class
├── models/
│   ├── quiz_question.dart       # QuizQuestion model
│   └── app_config.dart          # IntroConfig, SuccessConfig (optional)
├── data/
│   └── quiz_data.dart           # defaultQuizData list + default config strings
├── screens/
│   └── home_screen.dart         # Home screen scaffold + modal orchestration
├── widgets/
│   ├── home_dashboard.dart      # Static dashboard content (header, tabs, booking card)
│   ├── quiz_modal.dart          # Modal overlay container (manages intro/quiz/success steps)
│   ├── intro_step.dart          # Intro content within modal
│   ├── quiz_step.dart           # Quiz flow within modal (progress bar, question, options)
│   ├── success_step.dart        # Success/certified content within modal
│   ├── option_card.dart         # Single quiz option card widget
│   └── restart_toast.dart       # Top-sliding toast overlay
└── services/
    └── storage_service.dart     # SharedPreferences wrapper for quiz_passed state
```

---

## Language & Locale

- **All user-facing text is in Hindi (हिंदी).**
- Set `locale: Locale('hi')` in MaterialApp if needed.
- HTML lang in prototype: `<html lang="hi">`
- Tone: Casual, warm, positive. No blame tone. Benefit-first, action-later.
- See `design_reference/Wiom_Design_Guidelines_v1.txt` Section 2 for full UX writing guidelines.

---

## Design Reference Files

- `design_reference/style_reference.png` — Visual reference for the home screen and overall styling
- `design_reference/popup_reference.png` — Visual reference for the modal/popup design
- `design_reference/Wiom_Design_Guidelines_v1.txt` — Full Wiom design system documentation (colors, typography, UX writing, tone)

---

## Key Implementation Notes

1. **Modal is not a route** — It's an overlay on top of the home screen. Use `Stack` + `AnimatedOpacity`/`ScaleTransition` or `showGeneralDialog` with a custom builder. The home screen should be visible (dimmed) behind the modal.

2. **Modal has internal steps** — Intro, Quiz, and Success are all rendered within the same modal container. Use a state variable to switch between them, not separate modals.

3. **Quiz restart resets to question 0** — It does NOT close and reopen the modal. The quiz step just re-renders from Q1.

4. **Progress bar is inside the modal** — It sits at the very top of the modal sheet, above the scrollable content area.

5. **The home screen is entirely static** — No interactivity needed. It's a visual prop to simulate the real app context.

6. **No network calls** — Everything is local. Quiz data is hardcoded. State is in SharedPreferences.

7. **Mobile-first design** — The prototype constrains to 420px max-width. In Flutter on a real device, just use full screen width since phones are already narrow.
