# Universal AI Client Service (ai_client_service)

A production-ready, cross-platform Flutter chat application designed to interface seamlessly with various AI providers (LLMs). This application provides a rich, customizable chatting experience packed with advanced AI functionality, local data persistence, and secure credential management.

## 🚀 Features

- **Multi-Provider Support**: Connect to various LLM backends using a unified interface.
- **Local Chat History**: Persistent storage for all your user sessions, messages, and settings using [Isar Database](https://pub.dev/packages/isar).
- **Secure Storage**: Safe, encrypted storage for your API keys and sensitive provider configurations utilizing `flutter_secure_storage`.
- **Advanced Chat Capabilities**:
  - **Model Thinking Visualization**: Toggle and display the AI's internal reasoning or "thinking" process via a selectable dropdown.
  - **Token Usage Settings**: Configure "lite" or "extensive" token limits directly from settings with granular control.
  - **Automatic Chat Titling**: The app automatically generates concise, 3-5 word titles for your sessions based on the very first prompt.
  - **LLM Council**: A unique orchestration feature that runs parallel LLM calls through a Prompt Router, aggregates various models' responses, and summarizes the final output. Council members can be customized via settings.
- **Rich Media & Formatting**: Support for Markdown rendering, code syntax highlighting, and text-to-speech (TTS) playback.
- **Desktop First (but Cross-Platform)**: Fully optimized for Windows, macOS, and Linux using `window_manager` for custom window sizes and behaviors, but completely compatible with mobile targets.
- **Theming**: Dynamic light and dark themes with custom fonts using `google_fonts`. Dark modes feature both standard dim and "lights out" AMOLED variants.

## 🛠️ Technology Stack

- **Framework**: Flutter (SDK `^3.11.0`)
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Local Database**: [Isar](https://pub.dev/packages/isar)
- **Secure Storage**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- **Networking**: [Dio](https://pub.dev/packages/dio) with [dio_smart_retry](https://pub.dev/packages/dio_smart_retry)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Code Generation**: `build_runner`, `freezed`, `json_serializable`, `riverpod_generator`, `isar_generator`

## 📁 Project Structure

```text
lib/
├── core/
│   ├── router/         # GoRouter configurations and routes
│   ├── security/       # Secure storage implementation
│   └── theme/          # AppTheme, dark/light variants
├── data/
│   ├── datasources/    # Local (Isar) & Remote API integrations
│   └── models/         # Isar schemas and Freezed dataclasses
├── domain/
│   └── repositories/   # Abstract contracts (e.g., AIRepository)
├── presentation/
│   ├── providers/      # Riverpod state notifiers and providers
│   └── screens/        # UI layer (Chat, History, Settings, Shell)
└── main.dart           # App entry point and window manager setup
```

## 🏗️ Getting Started

### Prerequisites

- **Flutter SDK**: `3.11.0` or higher.
- **OS requirements**:
  - Windows: Visual Studio 2022 with Desktop development with C++
  - macOS: Xcode
  - Linux: CMake, Ninja, GTK development headers.

### Installation

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd ai_client_service
   ```

2. **Install Dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run Code Generation:**
   Because this project relies heavily on code generation (`Freezed`, `Riverpod`, `Isar`), you must run `build_runner` to generate the `.g.dart` and `.freezed.dart` files.

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App:**

   ```bash
   flutter run -d <windows/macos/linux/web/android/ios>
   ```

   *Note: For Windows, ensure your disk is not full so the Flutter build process can write temporary files.*

### Configuration

- **API Keys**: Configured through the app's settings screen and stored securely via the native keystore/keychain (`flutter_secure_storage`).
- **Database Path**: Isar defaults to the application documents directory, but can be customized in the UI (backed by `SharedPreferences`).

## ✍️ Development & Contribution

- **State Management**: All features should use Riverpod for state sharing. Use `riverpod_generator` for new providers.
- **Data Models**: Use `freezed` for immutable data classes and `isar` collections for persistent models. Separate Domain models from Data/Isar models where possible to maintain clean architecture.
- **Linting**: Ensure your code passes `flutter_lints` rules defined in `analysis_options.yaml`.
