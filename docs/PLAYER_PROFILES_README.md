# Player Profiles Module - Badminton Queuing System

## Overview
This module implements a complete player profile management system for the Badminton Queuing System. It follows industry-standard coding practices including Single Responsibility Principle, centralized business logic, and clean architecture.

## Architecture

### 📁 Project Structure
```
lib/
├── models/
│   ├── badminton_level.dart    # Enums for skill levels and strengths
│   └── player.dart              # Player data model
├── services/
│   └── player_service.dart      # Centralized business logic
├── utils/
│   └── validators.dart          # Form validation utilities
├── widgets/
│   ├── badminton_level_slider.dart  # Custom skill level slider
│   └── player_form.dart         # Reusable player form
├── screens/
│   ├── add_player_screen.dart   # Add new player
│   ├── players_list_screen.dart # List and search players
│   └── edit_player_screen.dart  # Edit existing player
└── main.dart                    # App entry point
```

## Features

### ✅ All Required Features Implemented

#### Part 1: Add Player Profile Screen
- ✅ Form with all required fields:
  - Nickname (text input with validation)
  - Full Name (text input with validation)
  - Contact Number (numeric input with validation)
  - Email (email input with validation)
  - Address (multiline text area)
  - Remarks (multiline text area)
- ✅ Custom badminton level slider:
  - Covers all 7 levels: Beginner → Intermediate → Level G → Level F → Level E → Level D → Open Player
  - Each level has 3 tick marks: Weak, Mid, Strong
  - Draggable range handles for min/max selection
- ✅ Action buttons: Save Player, Cancel
- ✅ Comprehensive input validation:
  - No empty required fields
  - Valid email format
  - Numeric-only phone number
  - Duplicate nickname/email detection

#### Part 2: List All Player Profiles Screen
- ✅ Search bar at the top for filtering by nickname or full name
- ✅ Player cards/rows displaying:
  - Nickname
  - Full Name
  - Current badminton level range
  - Avatar with first letter
- ✅ Swipe-to-delete functionality with confirmation dialog
- ✅ "Add New Player" floating action button
- ✅ Tappable player rows that navigate to edit screen
- ✅ Empty state UI for when no players exist

#### Part 3: Edit Player Profile Screen
- ✅ Reuses the same form layout as Add Player screen
- ✅ Pre-fills all fields with selected player's data
- ✅ Badminton level slider set to current values
- ✅ Action buttons:
  - "Update Player" – saves changes
  - "Cancel" – returns without saving
  - "Delete Player" – removes profile with confirmation
- ✅ Duplicate validation (excluding current player)

## Design Patterns & Best Practices

### 🏗️ Single Responsibility Principle
Each class has one clear purpose:
- **PlayerService**: Manages all player CRUD operations
- **Validators**: Handles all form validation logic
- **Player**: Represents player data
- **BadmintonLevelSlider**: Manages skill level selection UI
- **PlayerForm**: Handles form UI and user input

### 🎯 Centralized Business Logic
All business logic is contained in `PlayerService`:
- Player creation, updating, deletion
- Search functionality
- Duplicate detection
- Level range validation
- No business logic in UI components

### 🧩 Component Reusability
- `PlayerForm` is shared between Add and Edit screens
- `BadmintonLevelSlider` is a standalone reusable component
- `Validators` utility class provides reusable validation functions

### 🔄 State Management
Uses Provider pattern for reactive state management:
- Centralized state in `PlayerService`
- UI automatically updates when data changes
- Follows Flutter best practices

### ✅ Data Validation
- **Client-side validation** for immediate feedback
- **Service-level validation** for business rules
- **Duplicate checking** for nickname and email
- **Level range validation** to ensure min ≤ max

## Key Components

### 1. Player Model (`lib/models/player.dart`)
Immutable data class representing a player:
```dart
- id: Unique identifier (UUID)
- nickname: Player nickname
- fullName: Full legal name
- contactNumber: Phone number
- email: Email address
- address: Physical address
- remarks: Additional notes
- minLevel/minStrength: Minimum skill level
- maxLevel/maxStrength: Maximum skill level
- createdAt/updatedAt: Timestamps
```

### 2. PlayerService (`lib/services/player_service.dart`)
Centralized business logic service:
```dart
Methods:
- createPlayer(): Add new player
- updatePlayer(): Update existing player
- deletePlayer(): Remove player
- getPlayerById(): Retrieve player by ID
- searchPlayers(): Search by nickname/name
- isNicknameExists(): Check for duplicates
- isEmailExists(): Check for duplicates
- getPlayersByLevel(): Filter by skill level
```

### 3. Custom Badminton Level Slider
Advanced range slider with 21 positions (7 levels × 3 strengths):
- Visual display of current min/max selection
- Labels for all 7 skill levels
- Smooth dragging experience
- Real-time value updates

### 4. Form Validation
Comprehensive validation rules:
- **Nickname**: 2-20 characters
- **Full Name**: 2-50 characters
- **Phone**: 7-15 digits only
- **Email**: Valid RFC 5322 format
- **Address**: Minimum 10 characters

## Usage Guide

### Running the App
```bash
# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Build for release
flutter build ios
flutter build android
```

### Adding a Player
1. Tap the "Add New Player" floating button
2. Fill in all required fields (marked with *)
3. Adjust the skill level range using the slider
4. Tap "Save Player" to add the player
5. Validation errors will appear inline if any

### Viewing All Players
1. Main screen shows all players in a scrollable list
2. Use the search bar to filter by nickname or name
3. Tap any player card to view/edit details
4. Swipe left on a player card to reveal delete option

### Editing a Player
1. Tap on a player card from the list
2. Modify any fields as needed
3. Tap "Update Player" to save changes
4. Or use "Delete Player" to remove the profile
5. Tap "Cancel" to discard changes

### Deleting a Player
Two ways to delete:
1. **From List**: Swipe left on player card → Tap delete → Confirm
2. **From Edit Screen**: Tap delete button → Confirm

## Technical Details

### Dependencies
```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2    # State management
  uuid: ^4.5.1        # Unique ID generation
```

### Data Storage
Currently uses **in-memory storage** (data persists only during app session).

To add persistence, extend `PlayerService` to use:
- **SharedPreferences** for simple local storage
- **Sqflite** for SQLite database
- **Hive** for fast local database
- **Firebase** for cloud storage

### Platform Support
✅ iOS
✅ Android
✅ Web
✅ macOS
✅ Windows
✅ Linux

## Future Enhancements

### Recommended Improvements
1. **Persistent Storage**: Implement database storage
2. **Player Photos**: Add image upload/camera integration
3. **Statistics**: Track games played, wins/losses
4. **Export/Import**: CSV or JSON data transfer
5. **Dark Mode**: Theme switching support
6. **Multi-language**: Internationalization (i18n)
7. **Player QR Codes**: Quick check-in functionality
8. **Offline Sync**: Cloud synchronization when online

## Testing

### Manual Testing Checklist
- [ ] Add player with valid data
- [ ] Add player with invalid data (verify validation)
- [ ] Add duplicate nickname (verify rejection)
- [ ] Add duplicate email (verify rejection)
- [ ] Search for players by nickname
- [ ] Search for players by full name
- [ ] Edit player and save changes
- [ ] Edit player and cancel (verify no changes)
- [ ] Delete player via swipe-to-delete
- [ ] Delete player from edit screen
- [ ] Verify all skill level combinations
- [ ] Test on different screen sizes

### Unit Testing (Future)
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Code Quality

### Linting
```bash
# Check for linting issues
flutter analyze

# Auto-fix formatting
flutter format lib/
```

### Performance
- ✅ Uses `const` constructors where possible
- ✅ Proper disposal of controllers and resources
- ✅ Efficient list rendering with ListView.builder
- ✅ State updates only when necessary

## Troubleshooting

### Common Issues

**Issue**: Build fails with dependency errors
```bash
Solution: Run flutter pub get and flutter clean
```

**Issue**: Hot reload not working
```bash
Solution: Stop app and restart with flutter run
```

**Issue**: Keyboard overlaps input fields
```bash
Solution: Wrap body in SingleChildScrollView (already implemented)
```

## Contributing

When adding new features:
1. Follow single responsibility principle
2. Add validation for all inputs
3. Update this documentation
4. Test on multiple platforms
5. Run `flutter analyze` before committing

## Credits

Built following Flutter best practices and industry-standard Java coding principles.

---

**Module Status**: ✅ Complete - All requirements implemented
**Last Updated**: October 4, 2025

