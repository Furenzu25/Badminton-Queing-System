import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/player_service.dart';
import 'services/theme_service.dart';
import 'screens/players_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BadmintonQueueApp());
}

class BadmintonQueueApp extends StatelessWidget {
  const BadmintonQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Badminton Queue System',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            debugShowCheckedModeBanner: false,
            home: const PlayersListScreen(),
          );
        },
      ),
    );
  }
}
