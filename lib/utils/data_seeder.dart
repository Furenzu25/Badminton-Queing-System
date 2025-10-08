import '../models/badminton_level.dart';
import '../services/player_service.dart';

/// Data seeder for development and testing purposes
/// This class provides sample data to populate the app during development
///
/// ⚠️ IMPORTANT: This is for DEVELOPMENT/TESTING ONLY
/// Never automatically seed data in production!
class DataSeeder {
  DataSeeder._(); // Prevent instantiation

  /// Seed sample players into the PlayerService
  /// Call this method explicitly when you want to populate test data
  static void seedPlayers(PlayerService playerService) {
    // Clear existing players first (optional - remove if you want to keep existing)
    playerService.clearAllPlayers();

    // Sample players with realistic data
    final samplePlayers = [
      {
        'nickname': 'AceKing',
        'fullName': 'Michael Chen',
        'contactNumber': '+1234567890',
        'email': 'michael.chen@example.com',
        'address': '123 Main Street, San Francisco, CA 94102',
        'remarks': 'Plays every Tuesday and Thursday evening',
        'minLevel': BadmintonLevel.levelE,
        'minStrength': SkillStrength.mid,
        'maxLevel': BadmintonLevel.levelD,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'SmashQueen',
        'fullName': 'Sarah Johnson',
        'contactNumber': '+1234567891',
        'email': 'sarah.j@example.com',
        'address': '456 Oak Avenue, San Francisco, CA 94103',
        'remarks': 'Prefers doubles, available weekends',
        'minLevel': BadmintonLevel.levelF,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.levelE,
        'maxStrength': SkillStrength.mid,
      },
      {
        'nickname': 'RallyKing',
        'fullName': 'David Martinez',
        'contactNumber': '+1234567892',
        'email': 'david.m@example.com',
        'address': '789 Pine Street, Oakland, CA 94607',
        'remarks': 'New to competitive play',
        'minLevel': BadmintonLevel.intermediate,
        'minStrength': SkillStrength.strong,
        'maxLevel': BadmintonLevel.levelG,
        'maxStrength': SkillStrength.mid,
      },
      {
        'nickname': 'NetNinja',
        'fullName': 'Emily Wong',
        'contactNumber': '+1234567893',
        'email': 'emily.wong@example.com',
        'address': '321 Elm Road, Berkeley, CA 94704',
        'remarks': 'Excellent at net play, recovering from minor injury',
        'minLevel': BadmintonLevel.levelD,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.levelD,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'ProShuttle',
        'fullName': 'James Anderson',
        'contactNumber': '+1234567894',
        'email': 'james.a@example.com',
        'address': '654 Maple Drive, Palo Alto, CA 94301',
        'remarks': 'Former college player, looking for competitive matches',
        'minLevel': BadmintonLevel.openPlayer,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.openPlayer,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'BirdieGal',
        'fullName': 'Lisa Thompson',
        'contactNumber': '+1234567895',
        'email': 'lisa.t@example.com',
        'address': '987 Cedar Lane, San Jose, CA 95113',
        'remarks': 'Available for morning sessions only',
        'minLevel': BadmintonLevel.intermediate,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.intermediate,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'DriveForce',
        'fullName': 'Robert Lee',
        'contactNumber': '+1234567896',
        'email': 'robert.lee@example.com',
        'address': '147 Birch Street, Fremont, CA 94538',
        'remarks': 'Powerful drives, learning footwork',
        'minLevel': BadmintonLevel.levelG,
        'minStrength': SkillStrength.mid,
        'maxLevel': BadmintonLevel.levelF,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'ClearMaster',
        'fullName': 'Jessica Brown',
        'contactNumber': '+1234567897',
        'email': 'jessica.b@example.com',
        'address': '258 Willow Court, Mountain View, CA 94040',
        'remarks': 'Great defensive player',
        'minLevel': BadmintonLevel.levelF,
        'minStrength': SkillStrength.strong,
        'maxLevel': BadmintonLevel.levelE,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'DropShot',
        'fullName': 'Kevin Park',
        'contactNumber': '+1234567898',
        'email': 'kevin.park@example.com',
        'address': '369 Spruce Avenue, Sunnyvale, CA 94086',
        'remarks': 'Precise drop shots, working on stamina',
        'minLevel': BadmintonLevel.levelE,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.levelE,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'NewbiePro',
        'fullName': 'Amanda Garcia',
        'contactNumber': '+1234567899',
        'email': 'amanda.g@example.com',
        'address': '741 Redwood Lane, Santa Clara, CA 95050',
        'remarks': 'Just started, very enthusiastic',
        'minLevel': BadmintonLevel.beginner,
        'minStrength': SkillStrength.weak,
        'maxLevel': BadmintonLevel.beginner,
        'maxStrength': SkillStrength.strong,
      },
      {
        'nickname': 'SpeedDemon',
        'fullName': 'Thomas Wilson',
        'contactNumber': '+1234567800',
        'email': 'thomas.w@example.com',
        'address': '852 Ash Street, Cupertino, CA 95014',
        'remarks': 'Fast reflexes, practicing consistency',
        'minLevel': BadmintonLevel.levelG,
        'minStrength': SkillStrength.strong,
        'maxLevel': BadmintonLevel.levelF,
        'maxStrength': SkillStrength.mid,
      },
      {
        'nickname': 'BackhandBoss',
        'fullName': 'Michelle Taylor',
        'contactNumber': '+1234567801',
        'email': 'michelle.t@example.com',
        'address': '963 Cherry Road, Milpitas, CA 95035',
        'remarks': 'Strong backhand, available evenings',
        'minLevel': BadmintonLevel.levelD,
        'minStrength': SkillStrength.mid,
        'maxLevel': BadmintonLevel.openPlayer,
        'maxStrength': SkillStrength.weak,
      },
    ];

    // Create each player
    int successCount = 0;
    for (final data in samplePlayers) {
      try {
        playerService.createPlayer(
          nickname: data['nickname'] as String,
          fullName: data['fullName'] as String,
          contactNumber: data['contactNumber'] as String,
          email: data['email'] as String,
          address: data['address'] as String,
          remarks: data['remarks'] as String,
          minLevel: data['minLevel'] as BadmintonLevel,
          minStrength: data['minStrength'] as SkillStrength,
          maxLevel: data['maxLevel'] as BadmintonLevel,
          maxStrength: data['maxStrength'] as SkillStrength,
        );
        successCount++;
      } catch (e) {
        // Skip if there's an error (e.g., duplicate)
        print('⚠️  Failed to seed player ${data['nickname']}: $e');
      }
    }

    print('✅ Seeded $successCount players successfully!');
  }

  /// Seed a small set of players for quick testing
  static void seedQuickTest(PlayerService playerService) {
    playerService.clearAllPlayers();

    playerService.createPlayer(
      nickname: 'TestUser1',
      fullName: 'Test User One',
      contactNumber: '+1234567890',
      email: 'test1@example.com',
      address: '123 Test Street, Test City, TC 12345',
      remarks: 'Test player for development',
      minLevel: BadmintonLevel.beginner,
      minStrength: SkillStrength.mid,
      maxLevel: BadmintonLevel.intermediate,
      maxStrength: SkillStrength.mid,
    );

    playerService.createPlayer(
      nickname: 'TestUser2',
      fullName: 'Test User Two',
      contactNumber: '+1234567891',
      email: 'test2@example.com',
      address: '456 Test Avenue, Test City, TC 12345',
      remarks: 'Another test player',
      minLevel: BadmintonLevel.levelE,
      minStrength: SkillStrength.strong,
      maxLevel: BadmintonLevel.levelD,
      maxStrength: SkillStrength.mid,
    );

    print('✅ Seeded 2 test players!');
  }

  /// Clear all seeded data
  static void clearData(PlayerService playerService) {
    playerService.clearAllPlayers();
    print('🗑️  Cleared all player data');
  }
}
