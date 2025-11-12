# 📚 Complete Function Reference Guide

This document explains **every single function** in the Badminton Queuing System and why it was added.

---

## 📦 Models

### `BadmintonLevel` (Enum)
**File:** `lib/models/badminton_level.dart`

#### **Why it exists:**
Represents the skill levels in badminton following a standardized progression system.

#### **Functions:**

##### `String get displayName`
- **Purpose:** Converts enum values to user-friendly text
- **Why:** We can't show "levelG" to users - they need to see "Level G"
- **Example:** `BadmintonLevel.levelG.displayName` → `"Level G"`

##### `static BadmintonLevel fromIndex(int index)`
- **Purpose:** Converts a numeric index to a BadmintonLevel enum
- **Why:** The slider widget returns integer positions (0-6), we need to convert them to enum values
- **Example:** `BadmintonLevel.fromIndex(3)` → `BadmintonLevel.levelF`
- **Used in:** `BadmintonLevelSlider` widget to convert slider positions

---

### `SkillStrength` (Enum)
**File:** `lib/models/badminton_level.dart`

#### **Why it exists:**
Provides granularity within each level (Weak/Mid/Strong) for more precise skill measurement.

#### **Functions:**

##### `String get displayName`
- **Purpose:** Converts enum to readable text
- **Why:** Same as BadmintonLevel - user-friendly display
- **Example:** `SkillStrength.mid.displayName` → `"Mid"`

##### `static SkillStrength fromIndex(int index)`
- **Purpose:** Converts numeric index (0-2) to SkillStrength enum
- **Why:** Slider returns numbers, we need enum values
- **Example:** `SkillStrength.fromIndex(1)` → `SkillStrength.mid`
- **Used in:** `BadmintonLevelSlider` for strength selection

---

### `Player` Model
**File:** `lib/models/player.dart`

#### **Why it exists:**
Represents a badminton player with all their details. This is the core data structure for player management.

#### **Constructor: `Player({...})`**
- **Purpose:** Standard constructor for creating Player instances
- **Why:** Allows manual creation with all fields specified
- **When used:** Internally by the service layer when updating players

#### **Factory: `Player.create({...})`**
- **Purpose:** Convenient way to create new players with auto-generated ID and timestamps
- **Why:** 
  - Automatically generates unique ID using UUID
  - Sets creation and update timestamps
  - Cleaner API - users don't need to provide ID/timestamps
- **Example:**
  ```dart
  Player.create(
    nickname: "JohnD",
    fullName: "John Doe",
    // ... other fields
  )
  ```
- **Used in:** `PlayerService.createPlayer()`

#### **Getter: `String get skillLevelRange`**
- **Purpose:** Creates formatted text showing player's skill range
- **Why:** 
  - DRY principle - format once, use everywhere
  - Handles both single level and range display
  - Consistent formatting across the app
- **Returns:** 
  - Single level: `"Level G (Weak)"`
  - Range: `"Level G (Weak) → Level E (Strong)"`
- **Used in:** Player list cards, view screens, search results

---

### `CourtSchedule` Model
**File:** `lib/models/court_schedule.dart`

#### **Why it exists:**
Represents a single court booking within a game. Allows games to have multiple court reservations.

#### **Constructor: `CourtSchedule({...})`**
- **Purpose:** Creates a schedule with validation
- **Why:** Ensures start time is always before end time
- **Validation:** `assert(startTime.isBefore(endTime))`

#### **Getter: `double get durationInHours`**
- **Purpose:** Calculates hours between start and end time
- **Why:** 
  - Needed for cost calculations (rate × hours)
  - Used throughout the app for displaying duration
- **Formula:** `(endTime - startTime).inMinutes / 60.0`
- **Returns:** `3.5` for 3 hours 30 minutes
- **Used in:** Cost calculations, duration displays

#### **Getter: `String get timeRange`**
- **Purpose:** Formats time as "6:00 PM - 9:00 PM"
- **Why:** Consistent time display throughout the app
- **Used in:** Game cards, schedule lists, view screens

#### **Getter: `String get dateFormatted`**
- **Purpose:** Formats date as "Nov 3, 2025"
- **Why:** Human-readable date format
- **Used in:** Game titles (when no custom title), schedule displays

#### **Private: `String _formatTime(DateTime time)`**
- **Purpose:** Helper to convert 24-hour to 12-hour format with AM/PM
- **Why:** Users prefer "6:00 PM" over "18:00"
- **Example:** `DateTime(2025, 11, 3, 18, 30)` → `"6:30 PM"`

---

### `Game` Model
**File:** `lib/models/game.dart`

#### **Why it exists:**
Central model representing a badminton game session with schedules, costs, and players.

#### **Constructor: `Game({...})`**
- **Purpose:** Standard constructor for manual instantiation
- **When used:** By the service layer for updates

#### **Factory: `Game.create({...})`**
- **Purpose:** Creates new games with auto-generated ID and timestamps
- **Why:** Same benefits as Player.create() - cleaner API
- **Used in:** `GameService.createGame()`

#### **Getter: `double get totalDurationInHours`**
- **Purpose:** Sums duration across ALL schedules
- **Why:** Games can have multiple court bookings (Court 1: 2hrs, Court 2: 3hrs)
- **Example:** 2 schedules of 2hrs each = 4 hours total
- **Used in:** Cost calculations

#### **Getter: `double get totalCourtCost`**
- **Purpose:** Calculates total cost (rate × total hours)
- **Why:** Single source of truth for cost calculation
- **Formula:** `courtRate × totalDurationInHours`
- **Example:** ₱400/hr × 3hrs = ₱1,200
- **Used in:** Cost summaries, billing displays

#### **Getter: `double get courtCostPerPlayer`**
- **Purpose:** Calculates cost split among players
- **Why:** 
  - "Divide equally" option needs this
  - Shows each player's share
- **Logic:**
  - If not dividing equally → returns 0
  - If no players → returns 0
  - Otherwise → `totalCourtCost / playerCount`
- **Example:** ₱1,200 ÷ 4 players = ₱300/player
- **Used in:** Player cost displays, billing

#### **Getter: `String get displayTitle`**
- **Purpose:** Smart title display with fallback
- **Why:** User can leave title blank - we auto-fill with date
- **Logic:**
  1. If title exists → use title
  2. If no title but has schedule → use first schedule's date
  3. If nothing → "Untitled Game"
- **Used in:** Game cards, headers, everywhere game is shown

#### **Getter: `String get scheduleSummary`**
- **Purpose:** Brief schedule description for cards
- **Why:** Can't show all schedules in list view - need summary
- **Logic:**
  - No schedules → "No schedule"
  - One schedule → "Court 1: 6:00 PM - 9:00 PM"
  - Multiple → "3 courts scheduled"
- **Used in:** Game list cards

---

### `UserSettings` Model
**File:** `lib/models/user_settings.dart`

#### **Why it exists:**
Stores default values for creating new games, saving user time.

#### **Constructor: `UserSettings({...})`**
- **Purpose:** Standard constructor
- **When used:** By SettingsService when updating

#### **Factory: `UserSettings.defaults()`**
- **Purpose:** Creates settings with sensible defaults
- **Why:** First-time users need initial values
- **Defaults:**
  - Court name: "Court 1"
  - Court rate: ₱400/hour
  - Shuttle cock: ₱150
  - Divide equally: Yes
- **Used in:** `SettingsService` initialization

---

## 🔧 Services

### `PlayerService`
**File:** `lib/services/player_service.dart`

#### **Why it exists:**
Centralized business logic for ALL player operations. Single Responsibility Principle - one service handles all player CRUD.

#### **Getter: `List<Player> get players`**
- **Purpose:** Provides read-only access to all players
- **Why:** 
  - Prevents external code from modifying the list directly
  - Returns unmodifiable copy for safety
- **Used in:** All screens that display players

#### **Method: `Player createPlayer({...})`**
- **Purpose:** Creates and adds new player
- **Why:** 
  - Validates skill level range before creating
  - Calls `Player.create()` factory
  - Notifies UI listeners for reactive updates
  - Returns created player for immediate use
- **Validation:** Ensures min level ≤ max level
- **Throws:** `ArgumentError` if validation fails
- **Used in:** `AddPlayerScreen`

#### **Method: `Player? updatePlayer(String playerId, {...})`**
- **Purpose:** Updates existing player by ID
- **Why:** 
  - Finds player by ID
  - Validates new data
  - Preserves ID and createdAt
  - Updates updatedAt timestamp
  - Notifies listeners
- **Returns:** Updated player, or `null` if not found
- **Used in:** `EditPlayerScreen`

#### **Method: `bool deletePlayer(String playerId)`**
- **Purpose:** Removes player by ID
- **Why:** Safe deletion with success/failure indication
- **Returns:** `true` if deleted, `false` if not found
- **Used in:** Swipe-to-delete in `PlayersListScreen`

#### **Method: `List<Player> searchPlayers(String query)`**
- **Purpose:** Filters players by nickname or full name
- **Why:** 
  - Case-insensitive search for better UX
  - Returns all players if query is empty
- **Used in:** Search bars in player lists

#### **Method: `bool isNicknameExists(String nickname, {String? excludePlayerId})`**
- **Purpose:** Checks if nickname is already taken
- **Why:** 
  - Prevents duplicate nicknames
  - `excludePlayerId` allows checking when editing (ignore self)
- **Used in:** `PlayerValidationHelper` for duplicate checking

#### **Method: `bool isEmailExists(String email, {String? excludePlayerId})`**
- **Purpose:** Checks if email is already used
- **Why:** Same as nickname - prevent duplicates
- **Used in:** `PlayerValidationHelper`

#### **Private Method: `bool _isValidLevelRange(...)`**
- **Purpose:** Validates min ≤ max for levels and strengths
- **Why:** Business logic - can't have "Level E" as minimum and "Level G" as maximum
- **Logic:**
  1. If min level > max level → invalid
  2. If same level but min strength > max strength → invalid
- **Used in:** `createPlayer()` and `updatePlayer()`

#### **Method: `void clearAllPlayers()`**
- **Purpose:** Deletes all players
- **Why:** Testing and data seeding (developer tools)
- **Used in:** Data seeder, developer menu

---

### `GameService`
**File:** `lib/services/game_service.dart`

#### **Why it exists:**
Manages all game CRUD operations and player assignments. Following SRP - one service for games.

#### **Getter: `List<Game> get games`**
- **Purpose:** Read-only access to all games
- **Why:** Same as PlayerService - safety and encapsulation
- **Used in:** All screens displaying games

#### **Method: `Game createGame({...})`**
- **Purpose:** Creates and validates new game
- **Why:** 
  - Validates all inputs (court name, schedules, rates)
  - Ensures schedules are valid (end > start)
  - Creates game with UUID
  - Adds to list and notifies listeners
- **Validation:**
  - Court name not empty
  - At least one schedule
  - Positive court rate and shuttle price
  - Valid time ranges
- **Throws:** `ArgumentError` on validation failure
- **Used in:** `AddGameScreen`

#### **Method: `bool deleteGame(String gameId)`**
- **Purpose:** Removes game by ID
- **Why:** Safe deletion with result indication
- **Returns:** `true` if deleted, `false` if not found
- **Used in:** Swipe-to-delete, view screen delete button

#### **Method: `List<Game> searchGames(String query)`**
- **Purpose:** Searches games by title or date
- **Why:** 
  - Case-insensitive
  - Searches both title and schedule dates
  - Empty query returns all games
- **Used in:** Search bar in `AllGamesScreen`

#### **Method: `bool addPlayerToGame(String gameId, String playerId)`**
- **Purpose:** Adds a player to a game
- **Why:**
  - Prevents duplicate additions
  - Updates game with new player list
  - Updates timestamp
  - Notifies listeners for reactive UI (cost per player updates)
- **Returns:** `false` if player already in game or game not found
- **Used in:** `AddPlayersToGameScreen`

#### **Method: `bool removePlayerFromGame(String gameId, String playerId)`**
- **Purpose:** Removes player from game
- **Why:** 
  - Allows removing players
  - Updates costs automatically
  - Notifies listeners
- **Returns:** `false` if player not in game or game not found
- **Used in:** `ViewGameScreen`, `AddPlayersToGameScreen`

#### **Method: `void clearAllGames()`**
- **Purpose:** Deletes all games
- **Why:** Testing and seeding (developer tools)
- **Used in:** Data seeder, developer menu

---

### `SettingsService`
**File:** `lib/services/settings_service.dart`

#### **Why it exists:**
Manages user preferences for default game values. Makes creating games faster.

#### **Getter: `UserSettings get settings`**
- **Purpose:** Access current settings
- **Why:** Screens need to read defaults when creating games
- **Used in:** `AddGameScreen`, `SettingsScreen`

#### **Method: `void updateSettings({...})`**
- **Purpose:** Saves new settings
- **Why:** 
  - Updates all settings at once
  - Notifies listeners so UI updates
- **Used in:** `SettingsScreen` save button

#### **Method: `void resetToDefaults()`**
- **Purpose:** Resets to initial defaults
- **Why:** User convenience - quick reset
- **Used in:** `SettingsScreen` reset button

---

### `ThemeService`
**File:** `lib/services/theme_service.dart`

#### **Why it exists:**
Manages light/dark mode switching across the app.

#### **Getter: `ThemeMode get themeMode`**
- **Purpose:** Current theme state
- **Why:** MaterialApp needs this to apply theme
- **Used in:** `main.dart`

#### **Getter: `bool get isDarkMode`**
- **Purpose:** Quick check if dark mode is active
- **Why:** UI elements may need to check theme state
- **Used in:** Theme toggle switches

#### **Method: `void toggleTheme()`**
- **Purpose:** Switches between light and dark
- **Why:** User action to change theme
- **Used in:** Theme toggle button (if implemented)

#### **Method: `void setThemeMode(ThemeMode mode)`**
- **Purpose:** Sets specific theme mode
- **Why:** More control than toggle
- **Used in:** Settings if you add theme selection

---

## 🛠️ Utilities

### `Validators`
**File:** `lib/utils/validators.dart`

#### **Why it exists:**
Centralized form validation. DRY principle - validate once, use everywhere.

#### **Method: `static String? validateEmail(String? value)`**
- **Purpose:** Validates email format
- **Why:** Ensures valid email addresses
- **Regex:** RFC 5322 simplified pattern
- **Used in:** Player forms (email field)

#### **Method: `static String? validatePhoneNumber(String? value)`**
- **Purpose:** Validates phone numbers
- **Why:** 
  - Ensures numeric input
  - Removes formatting characters (spaces, dashes, parentheses)
  - Checks length (7-15 digits)
- **Used in:** Player forms (contact number)

#### **Method: `static String? validateNickname(String? value)`**
- **Purpose:** Validates nickname
- **Why:** 
  - Ensures not empty
  - Minimum 2 characters
  - Maximum 20 characters
- **Used in:** Player forms (nickname field)

#### **Method: `static String? validateFullName(String? value)`**
- **Purpose:** Validates full name
- **Why:**
  - Ensures not empty
  - Minimum 2 characters
  - Maximum 50 characters
- **Used in:** Player forms (full name field)

#### **Method: `static String? validateAddress(String? value)`**
- **Purpose:** Validates address
- **Why:**
  - Ensures not empty
  - Minimum 10 characters (reasonable address length)
- **Used in:** Player forms (address field)

#### **Method: `static String? validateCourtName(String? value)`**
- **Purpose:** Validates court name
- **Why:**
  - Ensures not empty
  - Minimum 2 characters
- **Used in:** Game forms, settings

#### **Method: `static String? validatePositiveNumber(String? value, String fieldName)`**
- **Purpose:** Validates numeric input > 0
- **Why:**
  - Ensures valid number format
  - Ensures positive (rates/prices can't be negative)
  - Dynamic field name for error messages
- **Used in:** Court rate, shuttle cock price fields

---

### `PlayerValidationHelper`
**File:** `lib/utils/player_validation_helper.dart`

#### **Why it exists:**
Specialized validation for player uniqueness. Avoids code duplication between Add and Edit screens.

#### **Method: `static bool validateUniqueness(...)`**
- **Purpose:** One-stop validation for nickname and email uniqueness
- **Why:**
  - DRY - both Add and Edit screens need this
  - Automatically shows appropriate error messages
  - Handles the "exclude self" case for editing
- **Returns:** `true` if valid (unique), `false` if duplicate found
- **Shows:** SnackBar with specific error message
- **Used in:** `AddPlayerScreen`, `EditPlayerScreen`

---

### `SnackBarHelper`
**File:** `lib/utils/snackbar_helper.dart`

#### **Why it exists:**
Consistent feedback messages throughout the app. DRY principle for UI feedback.

#### **Method: `static void showSuccess(BuildContext context, String message)`**
- **Purpose:** Shows green success message
- **Why:** Consistent success feedback
- **Used in:** After creating/updating/deleting anything

#### **Method: `static void showError(BuildContext context, String message)`**
- **Purpose:** Shows red error message
- **Why:** Consistent error feedback
- **Used in:** Validation failures, errors

#### **Method: `static void showWarning(BuildContext context, String message)`**
- **Purpose:** Shows yellow warning message
- **Why:** Non-critical warnings (e.g., duplicate nickname)
- **Used in:** Validation warnings

#### **Method: `static void showInfo(BuildContext context, String message)`**
- **Purpose:** Shows blue info message
- **Why:** General information
- **Used in:** Informational messages

---

### `DataSeeder`
**File:** `lib/utils/data_seeder.dart`

#### **Why it exists:**
Developer convenience - quickly populate app with test data.

#### **Method: `static void seedPlayers(PlayerService playerService)`**
- **Purpose:** Creates 8 sample players
- **Why:** 
  - Testing without manual data entry
  - Demonstrates various skill levels
- **Used in:** Developer menu in `PlayersListScreen`

#### **Method: `static void seedQuickTestPlayers(...)`**
- **Purpose:** Creates just 2 players quickly
- **Why:** Fast testing, minimal data
- **Used in:** Developer menu (quick test option)

#### **Method: `static void clearPlayers(PlayerService playerService)`**
- **Purpose:** Deletes all players
- **Why:** Clean slate for testing
- **Used in:** Developer menu

#### **Method: `static void seedGames(GameService gameService)`**
- **Purpose:** Creates 5 diverse sample games
- **Why:**
  - Various schedules (today, tomorrow, next week)
  - Different court configurations
  - Testing multi-schedule support
- **Used in:** Developer menu in `AllGamesScreen`

#### **Method: `static void seedQuickTestGames(...)`**
- **Purpose:** Creates 2 quick test games
- **Why:** Minimal data for fast testing
- **Used in:** Developer menu

#### **Method: `static void clearGames(GameService gameService)`**
- **Purpose:** Deletes all games
- **Why:** Clean slate
- **Used in:** Developer menu

---

## 🎨 Widgets

### `BadmintonLevelSlider`
**File:** `lib/widgets/badminton_level_slider.dart`

#### **Why it exists:**
Custom dual-handle range slider for selecting skill levels. Built specifically for the "Weak/Mid/Strong" requirement.

#### **Method: `void _handleMinLevelChange(int value)`**
- **Purpose:** Updates minimum level when slider moves
- **Why:** 
  - Converts slider position to level/strength
  - Calls parent's onChange callback
- **Used in:** Slider interaction

#### **Method: `void _handleMaxLevelChange(int value)`**
- **Purpose:** Updates maximum level when slider moves
- **Why:** Same as min - handles the right slider
- **Used in:** Slider interaction

---

### `PlayerForm`
**File:** `lib/widgets/player_form.dart`

#### **Why it exists:**
Reusable form for both Add and Edit player screens. DRY principle - one form, two uses.

#### **Method: `bool validateForm()`**
- **Purpose:** Triggers validation on all fields
- **Why:** Called before save to check all inputs
- **Returns:** `true` if all valid, `false` otherwise
- **Used in:** Save buttons in Add/Edit screens

#### **Method: `void populateFromPlayer(Player player)`**
- **Purpose:** Fills form with existing player data
- **Why:** Edit screen needs to pre-fill fields
- **Used in:** `EditPlayerScreen` initialization

#### **Method: `Player getPlayerData()`**
- **Purpose:** Collects all form values into Player object
- **Why:** Save button needs to gather all data
- **Used in:** Save handlers in Add/Edit screens

---

## 🎯 Summary by Category

### **Data Display (Getters)**
- Show formatted information to users
- Examples: `skillLevelRange`, `displayTitle`, `timeRange`

### **Data Transformation**
- Convert between formats
- Examples: `fromIndex()`, `_formatTime()`, `durationInHours`

### **Data Creation (Factories)**
- Convenient object creation with defaults
- Examples: `Player.create()`, `Game.create()`, `UserSettings.defaults()`

### **Business Logic (Services)**
- CRUD operations with validation
- Examples: `createPlayer()`, `addPlayerToGame()`, `searchGames()`

### **Validation**
- Ensure data quality before saving
- Examples: All `Validators` methods, `validateUniqueness()`

### **User Feedback**
- Inform users of results
- Examples: All `SnackBarHelper` methods

### **Developer Tools**
- Speed up testing
- Examples: All `DataSeeder` methods

---

## 🎓 Key Principles Applied

1. **Single Responsibility Principle (SRP)**
   - Each function does ONE thing
   - Each service manages ONE entity type

2. **DRY (Don't Repeat Yourself)**
   - Reusable validators
   - Shared widgets (PlayerForm)
   - Centralized formatting (getters)

3. **Separation of Concerns**
   - Models: Data structure
   - Services: Business logic
   - Widgets: UI components
   - Utils: Helper functions

4. **Defensive Programming**
   - Validation before operations
   - Null safety
   - Error handling

5. **User Experience**
   - Auto-generated IDs (users don't need to create them)
   - Smart defaults (fallback titles)
   - Formatted displays (dates, times, currency)

---

## 📌 Quick Reference

**Want to add a player?** → `PlayerService.createPlayer()`  
**Want to search players?** → `PlayerService.searchPlayers()`  
**Want to validate an email?** → `Validators.validateEmail()`  
**Want to show success message?** → `SnackBarHelper.showSuccess()`  
**Want to add player to game?** → `GameService.addPlayerToGame()`  
**Want to calculate cost per player?** → `Game.courtCostPerPlayer` getter  
**Want test data?** → `DataSeeder.seedPlayers()` or `DataSeeder.seedGames()`

---

**End of Function Reference Guide** 🎉

