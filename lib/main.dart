import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/player_service.dart';
import 'screens/players_list_screen.dart';

void main() {
  runApp(const BadmintonQueueApp());
}

class BadmintonQueueApp extends StatelessWidget {
  const BadmintonQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerService(),
      child: MaterialApp(
        title: 'Badminton Queue System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const PlayersListScreen(),
      ),
    );
  }
}
