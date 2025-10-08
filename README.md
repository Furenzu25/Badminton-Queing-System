# Badminton Queuing System

A modern, cross-platform mobile application built with Flutter for managing badminton player profiles and queuing systems. Features a beautiful, minimalist UI with full light and dark mode support.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Material](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)

## 📋 About The Project

The Badminton Queuing System is a comprehensive player management application designed for badminton clubs, recreational centers, and tournament organizers. It provides an intuitive interface for managing player profiles, tracking skill levels, and organizing player information efficiently.

### Key Features

#### ✨ Player Management
- **Add Players**: Create detailed player profiles with comprehensive information
- **Edit Players**: Update player details and skill levels anytime
- **Delete Players**: Remove players with confirmation dialogs
- **Search**: Real-time search by nickname or full name
- **Swipe to Delete**: Modern gesture-based deletion with Material Design

#### 🎨 Modern UI/UX
- **Light & Dark Mode**: Beautiful themes with one-tap switching
  - Dark mode with blue accent highlights
  - Light mode with warm color palette
- **Material Design 3**: Latest design principles and components
- **System Fonts**: Native typography (SF Pro on iOS, Roboto on Android, Segoe UI on Windows)
- **Responsive Design**: Adapts to all screen sizes
- **Smooth Animations**: Polished interactions and transitions

#### 🎯 Skill Level System
- **7 Skill Levels**: Beginner → Intermediate → Level G → Level F → Level E → Level D → Open Player
- **Strength Tiers**: Weak, Mid, Strong within each level
- **Range Selection**: Set minimum and maximum skill ranges
- **Visual Slider**: Interactive range slider for easy selection

#### 📱 Form Validation
- **Required Fields**: Nickname, Full Name, Contact, Email, Address
- **Email Validation**: RFC 5322 compliant email checking
- **Phone Validation**: Numeric-only contact numbers (7-15 digits)
- **Duplicate Detection**: Prevents duplicate nicknames and emails
- **Real-time Feedback**: Inline validation messages

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.8.1 or higher)
2. **Dart SDK** (3.0 or higher) - comes with Flutter
3. **IDE** - Choose one:
   - [Visual Studio Code](https://code.visualstudio.com/) with Flutter extension
   - [Android Studio](https://developer.android.com/studio) with Flutter plugin
   - [IntelliJ IDEA](https://www.jetbrains.com/idea/) with Flutter plugin

4. **Platform-specific tools**:
   - **For iOS development**: Xcode (macOS only)
   - **For Android development**: Android SDK
   - **For Web development**: Chrome browser

### Installing Flutter

#### macOS
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Windows
```bash
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
# Extract to desired location (e.g., C:\src\flutter)

# Add Flutter to PATH in System Environment Variables
# Add: C:\src\flutter\bin

# Verify installation
flutter doctor
```

#### Linux
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:$HOME/development/flutter/bin"

# Verify installation
flutter doctor
```

### Project Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/badminton-queuing-system.git
cd badminton-queuing-system
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Verify setup**
```bash
flutter doctor -v
```

4. **Run the app**

For iOS Simulator:
```bash
flutter run -d ios
```

For Android Emulator:
```bash
flutter run -d android
```

For Web:
```bash
flutter run -d chrome
```

For a specific device:
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Building for Production

#### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (for Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS
```bash
flutter build ios --release
# Then open in Xcode for signing and distribution
```

#### Web
```bash
flutter build web --release
# Output: build/web/
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point with theme setup
├── models/                        # Data models
│   ├── badminton_level.dart     # Skill level enums
│   └── player.dart              # Player model
├── services/                      # Business logic layer
│   ├── player_service.dart      # Player CRUD operations
│   └── theme_service.dart       # Theme management
├── utils/                         # Utility classes
│   ├── validators.dart          # Form validation
│   ├── snackbar_helper.dart     # Snackbar utilities
│   └── player_validation_helper.dart  # Player validation
├── widgets/                       # Reusable UI components
│   ├── badminton_level_slider.dart    # Custom skill slider
│   └── player_form.dart         # Reusable player form
├── screens/                       # App screens
│   ├── players_list_screen.dart # Main list view
│   ├── add_player_screen.dart   # Add player form
│   └── edit_player_screen.dart  # Edit player form
└── theme/                         # Theme configuration
    └── app_theme.dart           # Light & dark themes
```

## 🛠️ Technologies & Architecture

### Core Technologies
- **Flutter 3.8.1**: Cross-platform UI framework
- **Dart 3.0+**: Programming language
- **Material Design 3**: Latest design system

### State Management
- **Provider**: Reactive state management
- **ChangeNotifier**: Observable pattern for services

### Key Packages
```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2    # State management
  uuid: ^4.5.1        # Unique ID generation
  cupertino_icons: ^1.0.8
```

### Development Tools
- **Data Seeder**: Quickly populate the app with test data during development
  - 12 realistic sample players with diverse skill levels
  - 2 quick test players for rapid testing
  - Clear all data option

### Architecture Pattern
**Clean Architecture with Single Responsibility Principle**

- **Models**: Immutable data classes
- **Services**: Centralized business logic
- **Widgets**: Reusable UI components
- **Screens**: UI orchestration
- **Utils**: Helper functions and validators

### Design Principles
- ✅ Single Responsibility Principle (SRP)
- ✅ Centralized Business Logic
- ✅ No code duplication
- ✅ Separation of Concerns
- ✅ Industry-standard practices

## 🎨 Design System

### Color Palettes

**Dark Mode**
- Background: `#0A0A0A`
- Surface: `#141414`
- Accent: `#3B82F6` (Blue)
- Text: `#FAFAFA`

**Light Mode**
- Background: `#FBFBF9`
- Surface: `#FFFFFF`
- Accent: `#2C53B0` (Blue)
- Text: `#1C1917`

### Typography
- **Display Large**: 34px, Bold
- **Title Large**: 22px, Regular
- **Body Medium**: 14px, Regular
- **Label Small**: 11px, Medium

System fonts used:
- iOS/macOS: San Francisco (SF Pro)
- Android: Roboto
- Windows: Segoe UI

## 📖 Usage Guide

### Adding a Player
1. Tap the "Add Player" floating action button
2. Fill in all required fields (marked with validation)
3. Adjust skill level range using the interactive slider
4. Tap "Save Player" to add
5. View success message and return to list

### Searching Players
1. Use the search bar at the top of the list
2. Type nickname or full name
3. Results filter in real-time
4. Tap the X to clear search

### Editing a Player
1. Tap any player card from the list
2. Modify fields as needed
3. Adjust skill level if necessary
4. Tap "Update Player" to save
5. Or tap "Cancel" to discard changes

### Deleting a Player
**Method 1 - Swipe to Delete:**
1. Swipe left on a player card
2. Tap the red delete area
3. Confirm deletion in dialog

**Method 2 - From Edit Screen:**
1. Open player edit screen
2. Tap delete button (top right or bottom)
3. Confirm deletion in dialog

### Switching Themes
1. Tap the sun/moon icon in the app bar (top right)
2. Theme switches instantly
3. Choice persists during session

### Using Test Data (Development)

For development and testing, you can quickly populate the app with sample data:

1. **Tap the menu icon** (⋮) in the app bar
2. **Choose an option**:
   - **Seed Sample Data (12)**: Adds 12 realistic player profiles with varied skill levels
   - **Quick Test (2)**: Adds 2 basic test players for quick testing
   - **Clear All Data**: Removes all players (with confirmation)

**Note**: This feature is for development/testing only. Data is stored in memory and will be lost when the app restarts.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run widget tests
flutter test test/widget_test.dart
```

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Follow the existing code style and architecture
4. Ensure all files are under 300 lines
5. Add appropriate documentation
6. Commit changes (`git commit -m 'Add AmazingFeature'`)
7. Push to branch (`git push origin feature/AmazingFeature`)
8. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format lib/` before committing
- Run `flutter analyze` to check for issues
- Maintain single responsibility principle

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Your Name** - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- shadcn/ui for design inspiration
- Community contributors

## 📞 Support

For support, email support@example.com or open an issue on GitHub.

## 🔮 Future Enhancements

- [ ] Data persistence (SQLite/Hive)
- [ ] Queue management system
- [ ] Match scheduling
- [ ] Player statistics
- [ ] Export/Import functionality
- [ ] Cloud synchronization
- [ ] Multi-language support
- [ ] Player photos
- [ ] QR code check-in
- [ ] Tournament brackets

## 📚 Additional Documentation

- [Player Profiles Module](PLAYER_PROFILES_README.md) - Detailed module documentation
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md) - Technical implementation details
- [Theme Guide](THEME_GUIDE.md) - Design system documentation

---

**Built with ❤️ using Flutter**
