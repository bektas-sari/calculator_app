# Flutter Calculator App

A production-quality Flutter calculator with scientific mode, matching a dark, glossy UI design.

## Features

- **Basic Calculator**: 5×4 keypad with standard operations (+, −, ×, ÷, %)
- **Scientific Mode**: Trigonometric, logarithmic, and power functions
- **2nd Function Toggle**: Access alternate functions (asin, acos, atan, x³, ³√, etc.)
- **Angle Modes**: Toggle between degrees and radians
- **Memory Functions**: MS, MR, MC, M+, M−
- **History**: View and reuse last 20 evaluations
- **Proper Math**: Correct operator precedence, right-associative power, percent semantics
- **Accessible Design**: Semantic labels, color contrast AA, graceful error handling
- **Dark Theme**: Gradient background with blue accent buttons
- **Haptics & Animations**: Button feedback with scale animation

## Tech Stack

- Flutter 3.22+
- Dart 3.0+ (null safety)
- Riverpod for state management
- shared_preferences for persistence

## Project Structure

\`\`\`
lib/
├── main.dart
├── app/
│   └── theme/
│       └── app_theme.dart
└── features/
└── calculator/
├── presentation/
│   ├── pages/calculator_page.dart
│   └── widgets/
├── application/
│   └── providers/calculator_provider.dart
├── domain/
│   └── entities/calculation_result.dart
└── infrastructure/
└── services/
\`\`\`

## Getting Started

### Prerequisites
- Flutter 3.22+
- Dart 3.0+

### Setup

\`\`\`bash
flutter pub get
\`\`\`

### Run

\`\`\`bash
flutter run
\`\`\`

### Tests

\`\`\`bash
flutter test
\`\`\`

## Features Guide

### Basic Operations
Tap number and operator buttons sequentially. Press `=` to evaluate.

### Scientific Mode
Toggle with the scientific button to access trig, log, and power functions.

### 2nd Function
Press `2nd` to toggle alternate functions. Labels update dynamically.

### Angle Modes
Toggle between degrees and radians with the `deg/rad` button. Current mode persists.

### Memory
- **MS**: Store current result
- **MR**: Recall stored value
- **MC**: Clear memory
- **M+**: Add to memory
- **M−**: Subtract from memory

### History
Tap history icon to view last 20 calculations. Tap any result to reuse it.

### Gestures
- **Swipe left on display**: Delete last token
- **Long-press AC**: Clear history
- **Long-press ⌫**: Clear current entry
- **Long-press =**: Re-evaluate with current mode

## Design

- **Dark gradient background**: #0B0E12 → #11151B
- **Operator buttons**: Vivid blue (#2F6BFF) with white text
- **Numeric buttons**: Dark surfaces (#1A1F27 idle, #151A21 pressed)
- **Typography**: SF Pro family, 56–64sp result, 14–16sp expression
- **Accessibility**: AA color contrast, semantic labels, text scaling

## Accepted Test Cases

- ✓ 6000/2+3227*2 = 12,454 (en_US)
- ✓ 2+2*2 = 6; (2+2)*2 = 8
- ✓ 2^3^2 = 512 (right-associative)
- ✓ sin(30°) = 0.5; sin(π/6 rad) = 0.5
- ✓ 200+10% = 220; 200×10% = 20
- ✓ 50! exact; 171! overflow
- ✓ Scientific notation support
- ✓ Memory operations
- ✓ History persists across sessions

## Known Limitations

- Gamma function (Γ) for non-integer factorials not implemented (can be added)
- Regex patterns for locale formatting vary by platform
- Complex numbers not supported (by spec)

## License

MIT
