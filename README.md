# Quizzical 🎯

A modern, responsive, and accessible quiz mobile application built with **Flutter** and **GetX**, powered by the **Open Trivia Database (OpenTDB) API**.

---

## ✨ Features

- **Welcome Screen**: Clean typography, personalized user greeting, and responsive layout.
- **Category Selection**:
  - Live category listing powered by OpenTDB API (`https://opentdb.com/api_category.php`).
  - Themed pastel cards with high-definition 3D illustrations.
  - Pull-to-refresh and session caching for zero-flicker re-entries.
  - Network failure handling with an in-app retry banner.
- **Quiz Configuration**:
  - Interactive slider to select question count (1 to 50, defaulting to 10).
  - Difficulty selection (Any, Easy, Medium, Hard).
  - Question Type selection (Any, Multiple Choice, True / False).
  - Local persistence via `SharedPreferences` remembering user choices across launches.
- **Interactive Quiz Play**:
  - 30-second countdown timer per question with visual color-coded warnings.
  - Automatic advance on timeout (marked incorrect).
  - Top `LinearProgressIndicator` tracking quiz progress.
  - Real-time answer feedback with distinct highlight states for correct and incorrect answers.
  - Exit confirmation dialog with automatic timer pause and resume.
- **Dynamic Results Screen**:
  - **High Score (≥ 60%)**: Celebratory confetti illustration and *"Congratulation"* banner.
  - **Low Score (< 60%)**: Encouraging illustration and *"Keep Trying!"* banner.
  - Performance analytics (Total Score, Accuracy %, Duration).
  - **Play Again** button preserving the previous configuration for instant replay.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter 3.x / Dart 3.x
- **State Management**: GetX (Controllers, Reactive Obx, and Named Routing)
- **Networking**: Dio with custom `ApiResponse` wrapper and API checkers
- **Local Persistence**: `shared_preferences`
- **Pattern**: Clean Architecture (Layered Presentation, Domain, Data, Core)

```
lib/
├── core/                  # Constants, design tokens, themes, utilities
├── data/                  # HTTP clients, network datasources, models
├── di_container.dart      # Dependency injection & service locator
├── features/
│   ├── categories/        # Category listing, models, service, and cards
│   ├── quiz/              # Quiz config, gameplay logic, timer, and results
│   └── splash/            # Welcome / Splash screen
├── routes/                # Named route definitions and bindings
└── main.dart              # Application bootstrap entrypoint
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Xcode (for iOS Simulator) or Android Studio

### Installation & Run
```bash
# Clone the repository
git clone https://github.com/iamnazmulhasan/quizzical.git
cd quizzical

# Install dependencies
flutter pub get

# Run on iOS Simulator
flutter run -d ios
```

---

## 🧪 Unit Testing

Run the test suite to verify scoring logic, Base64 decoding, and asset mappings:
```bash
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
