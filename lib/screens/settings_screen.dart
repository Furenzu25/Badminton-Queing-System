import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../utils/validators.dart';
import '../utils/snackbar_helper.dart';

/// User Settings Screen for managing default game configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttleCockPriceController = TextEditingController();
  bool _divideCourtEqually = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    final settings = Provider.of<SettingsService>(
      context,
      listen: false,
    ).settings;
    _courtNameController.text = settings.defaultCourtName;
    _courtRateController.text = settings.defaultCourtRate.toString();
    _shuttleCockPriceController.text = settings.defaultShuttleCockPrice
        .toString();
    _divideCourtEqually = settings.divideCourtEqually;
  }

  @override
  void dispose() {
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttleCockPriceController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final settingsService = Provider.of<SettingsService>(
        context,
        listen: false,
      );
      settingsService.updateSettings(
        defaultCourtName: _courtNameController.text,
        defaultCourtRate: double.parse(_courtRateController.text.trim()),
        defaultShuttleCockPrice: double.parse(
          _shuttleCockPriceController.text.trim(),
        ),
        divideCourtEqually: _divideCourtEqually,
      );

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Settings saved successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to save settings: ${e.toString()}',
        );
      }
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Reset to Defaults',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        content: Text(
          'Are you sure you want to reset all settings to default values?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final settingsService = Provider.of<SettingsService>(
                context,
                listen: false,
              );
              settingsService.resetToDefaults();
              _loadCurrentSettings();
              setState(() {});
              SnackBarHelper.showSuccess(context, 'Settings reset to defaults');
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Default Game Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set default values for new games',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Court Name
            TextFormField(
              controller: _courtNameController,
              decoration: const InputDecoration(
                labelText: 'Default Court Name',
                hintText: 'e.g., Court 1',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateCourtName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Court Rate
            TextFormField(
              controller: _courtRateController,
              decoration: const InputDecoration(
                labelText: 'Default Court Rate (per hour)',
                hintText: 'e.g., 400',
                border: OutlineInputBorder(),
                prefixText: '₱ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) =>
                  Validators.validatePositiveNumber(value, 'Court rate'),
            ),
            const SizedBox(height: 16),

            // Shuttle Cock Price
            TextFormField(
              controller: _shuttleCockPriceController,
              decoration: const InputDecoration(
                labelText: 'Default Shuttle Cock Price',
                hintText: 'e.g., 150',
                border: OutlineInputBorder(),
                prefixText: '₱ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => Validators.validatePositiveNumber(
                value,
                'Shuttle cock price',
              ),
            ),
            const SizedBox(height: 24),

            // Divide Court Equally Checkbox
            Card(
              child: CheckboxListTile(
                title: const Text('Divide court equally among players'),
                subtitle: Text(
                  _divideCourtEqually
                      ? 'Court costs will be split equally among all players'
                      : 'Court costs will be calculated per game',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                value: _divideCourtEqually,
                onChanged: (value) {
                  setState(() {
                    _divideCourtEqually = value ?? true;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            FilledButton(
              onPressed: _saveSettings,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
