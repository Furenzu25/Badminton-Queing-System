import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import '../widgets/player_form.dart';

/// Screen for editing an existing player profile
/// Following single responsibility principle - handles only the edit player UI
class EditPlayerScreen extends StatelessWidget {
  final Player player;

  const EditPlayerScreen({super.key, required this.player});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text(
            'Are you sure you want to permanently delete "${player.nickname}"?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final playerService = Provider.of<PlayerService>(
                  context,
                  listen: false,
                );
                playerService.deletePlayer(player.id);

                Navigator.of(dialogContext).pop(); // Close dialog
                Navigator.of(context).pop(); // Close edit screen

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Player "${player.nickname}" deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Player Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Player',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PlayerForm(
              player: player,
              submitButtonText: 'Update Player',
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
                      // Check for duplicate nickname (excluding current player)
                      if (playerService.isNicknameExists(
                        nickname,
                        excludePlayerId: player.id,
                      )) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nickname "$nickname" already exists',
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      // Check for duplicate email (excluding current player)
                      if (playerService.isEmailExists(
                        email,
                        excludePlayerId: player.id,
                      )) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email "$email" already exists'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      // Update the player
                      playerService.updatePlayer(
                        player.id,
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
                          content: Text(
                            'Player "$nickname" updated successfully',
                          ),
                          backgroundColor: Colors.green,
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
          ),
          // Delete button at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete),
                label: const Text('Delete Player'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
