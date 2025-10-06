import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_service.dart';
import '../widgets/player_form.dart';
import '../utils/snackbar_helper.dart';
import '../utils/player_validation_helper.dart';

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
                // Validate uniqueness
                if (!PlayerValidationHelper.validateUniqueness(
                  context,
                  playerService,
                  nickname,
                  email,
                )) {
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
                SnackBarHelper.showSuccess(
                  context,
                  'Player "$nickname" added successfully',
                );

                // Navigate back
                Navigator.of(context).pop();
              } catch (e) {
                // Show error message
                SnackBarHelper.showError(context, 'Error: ${e.toString()}');
              }
            },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
