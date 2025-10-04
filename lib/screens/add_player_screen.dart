import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_service.dart';
import '../widgets/player_form.dart';

/// Screen for adding a new player profile
/// Following single responsibility principle - handles only the add player UI
class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Player')),
      body: PlayerForm(
        submitButtonText: 'Save Player',
        onSubmit:
            (
              nickname,
              fullName,
              contactNumber,
              email,
              address,
              remarks,
              minLevel,
              minStrength,
              maxLevel,
              maxStrength,
            ) {
              try {
                // Check for duplicate nickname
                if (playerService.isNicknameExists(nickname)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nickname "$nickname" already exists'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Check for duplicate email
                if (playerService.isEmailExists(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email "$email" already exists'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Create the player
                playerService.createPlayer(
                  nickname: nickname,
                  fullName: fullName,
                  contactNumber: contactNumber,
                  email: email,
                  address: address,
                  remarks: remarks,
                  minLevel: minLevel,
                  minStrength: minStrength,
                  maxLevel: maxLevel,
                  maxStrength: maxStrength,
                );

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Player "$nickname" added successfully'),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF10B981)
                        : Theme.of(context).colorScheme.tertiary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                // Navigate back
                Navigator.of(context).pop();
              } catch (e) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
