import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/badminton_level.dart';
import '../models/player.dart';
import '../utils/validators.dart';
import 'badminton_level_slider.dart';

/// Reusable form widget for adding and editing player profiles
/// Following single responsibility principle - handles form UI and validation
class PlayerForm extends StatefulWidget {
  final Player? player; // Null for add mode, Player for edit mode
  final Function(
    String nickname,
    String fullName,
    String contactNumber,
    String email,
    String address,
    String remarks,
    BadmintonLevel minLevel,
    SkillStrength minStrength,
    BadmintonLevel maxLevel,
    SkillStrength maxStrength,
  )
  onSubmit;
  final VoidCallback onCancel;
  final String submitButtonText;

  const PlayerForm({
    super.key,
    this.player,
    required this.onSubmit,
    required this.onCancel,
    required this.submitButtonText,
  });

  @override
  State<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _fullNameController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _remarksController;

  late BadmintonLevel _minLevel;
  late SkillStrength _minStrength;
  late BadmintonLevel _maxLevel;
  late SkillStrength _maxStrength;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with player data or empty strings
    _nicknameController = TextEditingController(
      text: widget.player?.nickname ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.player?.fullName ?? '',
    );
    _contactNumberController = TextEditingController(
      text: widget.player?.contactNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.player?.email ?? '');
    _addressController = TextEditingController(
      text: widget.player?.address ?? '',
    );
    _remarksController = TextEditingController(
      text: widget.player?.remarks ?? '',
    );

    // Initialize level data
    _minLevel = widget.player?.minLevel ?? BadmintonLevel.beginner;
    _minStrength = widget.player?.minStrength ?? SkillStrength.mid;
    _maxLevel = widget.player?.maxLevel ?? BadmintonLevel.intermediate;
    _maxStrength = widget.player?.maxStrength ?? SkillStrength.mid;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _nicknameController.text,
        _fullNameController.text,
        _contactNumberController.text,
        _emailController.text,
        _addressController.text,
        _remarksController.text,
        _minLevel,
        _minStrength,
        _maxLevel,
        _maxStrength,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Nickname field
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: 'Nickname *',
              hintText: 'Enter player nickname',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: Validators.validateNickname,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // Full Name field
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter full name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
            ),
            validator: Validators.validateFullName,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // Contact Number field
          TextFormField(
            controller: _contactNumberController,
            decoration: const InputDecoration(
              labelText: 'Contact Number *',
              hintText: 'Enter contact number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
            ],
            validator: Validators.validatePhoneNumber,
          ),
          const SizedBox(height: 16),

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              hintText: 'Enter email address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),

          // Address field
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address *',
              hintText: 'Enter address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            validator: Validators.validateAddress,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),

          // Remarks field
          TextFormField(
            controller: _remarksController,
            decoration: const InputDecoration(
              labelText: 'Remarks',
              hintText: 'Enter any additional remarks (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.notes),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),

          // Badminton Level Slider
          BadmintonLevelSlider(
            initialMinLevel: _minLevel,
            initialMinStrength: _minStrength,
            initialMaxLevel: _maxLevel,
            initialMaxStrength: _maxStrength,
            onChanged: (minLevel, minStrength, maxLevel, maxStrength) {
              setState(() {
                _minLevel = minLevel;
                _minStrength = minStrength;
                _maxLevel = maxLevel;
                _maxStrength = maxStrength;
              });
            },
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _handleSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(widget.submitButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
