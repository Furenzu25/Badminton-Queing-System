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
          title: const Text(
            'Delete Player',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${player.nickname}"? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium,
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
                    content: Text('${player.nickname} deleted'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
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
        title: const Text('Edit Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
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
          ),
          // Delete button at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete Player'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
