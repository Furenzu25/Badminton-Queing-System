# Data Seeder Guide

## 🌱 What is the Data Seeder?

The Data Seeder is a development tool that quickly populates your app with realistic test data. Instead of manually adding players one by one during development, you can instantly add 12 sample players with a single tap!

## ⚠️ Important Note

**This is for DEVELOPMENT and TESTING only!**
- Data is stored in memory (no persistence yet)
- Data will be lost when you restart the app
- Never use this in production
- It's opt-in only (you must explicitly choose to seed data)

## 🎯 Features

### 1. Seed Sample Data (12 Players)

Adds **12 realistic player profiles** with:
- Diverse skill levels (Beginner → Open Player)
- Realistic names and contact information
- Varied addresses (Bay Area locations)
- Different playing styles and preferences
- Mix of experience levels

**Sample players include:**
- AceKing (Level E-D, competitive)
- SmashQueen (Level F-E, weekend player)
- NetNinja (Level D, excellent net play)
- ProShuttle (Open Player, former college player)
- NewbiePro (Beginner, enthusiastic learner)
- And 7 more!

### 2. Quick Test (2 Players)

Adds **2 simple test players** for:
- Quick functionality testing
- UI verification
- Minimal data setup
- Fast development iteration

### 3. Clear All Data

Removes **ALL players** from the app:
- Shows confirmation dialog
- Displays count of players to be deleted
- Cannot be undone
- Useful for starting fresh

## 📱 How to Use

### Method 1: Using the UI

1. Open the app
2. Go to the Players list screen
3. Tap the **menu icon** (⋮) in the top right
4. Select one of the options:
   - **Seed Sample Data (12)**
   - **Quick Test (2)**
   - **Clear All Data**
5. See success message
6. Players appear in the list!

### Method 2: Programmatically (Advanced)

You can also call the seeder directly in your code:

```dart
import 'package:provider/provider.dart';
import 'utils/data_seeder.dart';
import 'services/player_service.dart';

// In your widget or screen
final playerService = Provider.of<PlayerService>(context, listen: false);

// Seed full sample data
DataSeeder.seedPlayers(playerService);

// Or seed quick test
DataSeeder.seedQuickTest(playerService);

// Or clear all
DataSeeder.clearData(playerService);
```

## 🎭 Sample Data Details

### Skill Level Distribution

The 12 sample players cover all skill levels:
- **Beginner**: 1 player
- **Intermediate**: 2 players
- **Level G**: 2 players
- **Level F**: 2 players
- **Level E**: 2 players
- **Level D**: 2 players
- **Open Player**: 1 player

### Sample Player Profiles

**AceKing** (Advanced)
- Full Name: Michael Chen
- Level: E (Mid) → D (Strong)
- Plays: Tuesday & Thursday evenings
- Style: Competitive

**NewbiePro** (Beginner)
- Full Name: Amanda Garcia
- Level: Beginner (Weak) → Beginner (Strong)
- Status: Just started
- Attitude: Very enthusiastic

**ProShuttle** (Expert)
- Full Name: James Anderson
- Level: Open Player (all)
- Background: Former college player
- Looking for: Competitive matches

## 🔧 Customizing the Seeder

Want to add your own sample data? Edit `lib/utils/data_seeder.dart`:

```dart
// Add more sample players
final samplePlayers = [
  {
    'nickname': 'YourNickname',
    'fullName': 'Your Full Name',
    'contactNumber': '+1234567890',
    'email': 'your.email@example.com',
    'address': 'Your Address',
    'remarks': 'Your remarks',
    'minLevel': BadmintonLevel.intermediate,
    'minStrength': SkillStrength.mid,
    'maxLevel': BadmintonLevel.levelG,
    'maxStrength': SkillStrength.strong,
  },
  // Add more...
];
```

## 🎓 Use Cases

### During Development
```dart
// Start fresh each time
DataSeeder.clearData(playerService);
DataSeeder.seedPlayers(playerService);
// Now you have consistent test data!
```

### For UI Testing
```dart
// Test with minimal data
DataSeeder.seedQuickTest(playerService);
// Perfect for testing empty states, list rendering, etc.
```

### For Demo/Presentation
```dart
// Show off with realistic data
DataSeeder.seedPlayers(playerService);
// Looks professional with varied player profiles!
```

### For Feature Testing
```dart
// Test search with many players
DataSeeder.seedPlayers(playerService);
// Search for "King", "Pro", "Net", etc.

// Test with different skill levels
DataSeeder.seedPlayers(playerService);
// Filter by level, test level slider, etc.
```

## 🐛 Troubleshooting

### "Failed to seed player" in console

This happens when:
- Player with same email already exists
- Player with same nickname already exists

**Solution**: Clear all data first, then seed:
```dart
DataSeeder.clearData(playerService);
DataSeeder.seedPlayers(playerService);
```

### Players disappear after restart

This is expected! Data is stored in memory only.

**Future Enhancement**: Add persistence (SQLite, Hive, etc.)

### Can't see the menu button

Make sure you're on the Players list screen. The menu (⋮) is in the top right of the app bar.

## 🔮 Future Enhancements

Planned improvements:
- [ ] Save seeded data to local storage
- [ ] Custom seed configurations
- [ ] Import/export seed data
- [ ] Generate random players on demand
- [ ] Seed data from CSV file
- [ ] Seed match history
- [ ] Seed tournament data

## 📝 Best Practices

### DO ✅
- Use seeded data for development and testing
- Clear data before seeding to avoid duplicates
- Customize sample data for your use case
- Use Quick Test for rapid iteration

### DON'T ❌
- Don't rely on seeded data in production
- Don't assume seeded data persists
- Don't commit changes to seeder with personal data
- Don't seed data in automated tests (use factories)

## 🧪 Testing with Seeded Data

```dart
// Example: Test search functionality
void testSearchWithSeedData() {
  final service = PlayerService();
  DataSeeder.seedPlayers(service);
  
  // Search for "King"
  final results = service.searchPlayers('King');
  
  // Should find "AceKing", "RallyKing"
  assert(results.length == 2);
}
```

## 🎯 Summary

The Data Seeder is your **time-saving tool** for development:

- ⚡ **Fast**: Populate data in seconds
- 🎭 **Realistic**: Professional-looking sample data
- 🔧 **Flexible**: Multiple seeding options
- 🧹 **Clean**: Easy to clear and start fresh
- 📱 **Accessible**: Available via UI menu

**Happy developing!** 🚀

---

**Location**: `lib/utils/data_seeder.dart`
**UI Integration**: `lib/screens/players_list_screen.dart`

