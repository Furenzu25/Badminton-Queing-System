import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../services/settings_service.dart';
import '../models/court_schedule.dart';
import '../utils/validators.dart';
import '../utils/snackbar_helper.dart';

/// Add Game Screen for creating new badminton games
class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttleCockPriceController = TextEditingController();
  bool _divideCourtEqually = true;

  final List<_ScheduleEntry> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultValues();
  }

  void _loadDefaultValues() {
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
    _titleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttleCockPriceController.dispose();
    for (final schedule in _schedules) {
      schedule.dispose();
    }
    super.dispose();
  }

  void _addSchedule() {
    setState(() {
      _schedules.add(_ScheduleEntry());
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules[index].dispose();
      _schedules.removeAt(index);
    });
  }

  Future<void> _pickDate(_ScheduleEntry entry) async {
    final date = await showDatePicker(
      context: context,
      initialDate: entry.date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        entry.date = date;
      });
    }
  }

  Future<void> _pickTime(_ScheduleEntry entry, bool isStartTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (entry.startTime ?? TimeOfDay.now())
          : (entry.endTime ?? TimeOfDay.now()),
    );

    if (time != null) {
      setState(() {
        if (isStartTime) {
          entry.startTime = time;
        } else {
          entry.endTime = time;
        }
      });
    }
  }

  void _saveGame() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate schedules count using Validators class
    final scheduleCountError = Validators.validateSchedulesNotEmpty(
      _schedules.length,
    );
    if (scheduleCountError != null) {
      SnackBarHelper.showError(context, scheduleCountError);
      return;
    }

    // Validate each schedule entry using Validators class
    for (int i = 0; i < _schedules.length; i++) {
      final schedule = _schedules[i];
      final scheduleError = Validators.validateScheduleEntry(
        scheduleNumber: i + 1,
        courtNumber: schedule.courtNumber,
        date: schedule.date,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
      );

      if (scheduleError != null) {
        SnackBarHelper.showError(context, scheduleError);
        return;
      }
    }

    try {
      final gameService = Provider.of<GameService>(context, listen: false);

      // Convert schedule entries to CourtSchedule objects
      final courtSchedules = _schedules.map((entry) {
        final date = entry.date!;
        final startTime = entry.startTime!;
        final endTime = entry.endTime!;

        final startDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          startTime.hour,
          startTime.minute,
        );

        final endDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          endTime.hour,
          endTime.minute,
        );

        return CourtSchedule(
          courtNumber: entry.courtNumber.trim(),
          startTime: startDateTime,
          endTime: endDateTime,
        );
      }).toList();

      gameService.createGame(
        title: _titleController.text,
        courtName: _courtNameController.text,
        schedules: courtSchedules,
        courtRate: double.parse(_courtRateController.text.trim()),
        shuttleCockPrice: double.parse(_shuttleCockPriceController.text.trim()),
        divideCourtEqually: _divideCourtEqually,
      );

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Game created successfully');
        // Clear the form after successful save
        setState(() {
          // Dispose schedule controllers before clearing
          for (final schedule in _schedules) {
            schedule.dispose();
          }
          _schedules.clear();

          // Clear main form fields
          _titleController.clear();
          _courtNameController.clear();
          _courtRateController.clear();
          _shuttleCockPriceController.clear();
        });

        // Reload defaults after clearing
        _loadDefaultValues();
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to create game: ${e.toString()}',
        );
      }
    }
  }

  void _resetForm() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Reset Form',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all fields and reset the form?',
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
              setState(() {
                // Dispose schedule controllers first
                for (final schedule in _schedules) {
                  schedule.dispose();
                }
                _schedules.clear();

                // Clear main form fields
                _titleController.clear();
                _courtNameController.clear();
                _courtRateController.clear();
                _shuttleCockPriceController.clear();
              });

              // Reload defaults after clearing
              _loadDefaultValues();
              SnackBarHelper.showSuccess(context, 'Form reset to defaults');
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
        title: const Text('Add New Game'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
            tooltip: 'Reset form',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Game Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Game Title (optional)',
                hintText: 'Leave blank to use schedule date',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Court Name
            TextFormField(
              controller: _courtNameController,
              decoration: const InputDecoration(
                labelText: 'Court Name',
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
                labelText: 'Court Rate (per hour)',
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
                labelText: 'Shuttle Cock Price',
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
            const SizedBox(height: 16),

            // Divide Court Equally Checkbox
            Card(
              child: CheckboxListTile(
                title: const Text('Divide court equally among players'),
                value: _divideCourtEqually,
                onChanged: (value) {
                  setState(() {
                    _divideCourtEqually = value ?? true;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Schedules Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Court Schedules',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                FilledButton.tonal(
                  onPressed: _addSchedule,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 18),
                      SizedBox(width: 4),
                      Text('Add Schedule'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_schedules.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 48,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No schedules added yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Schedule" to create one',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Schedule List
            ..._schedules.asMap().entries.map((entry) {
              final index = entry.key;
              final schedule = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Schedule ${index + 1}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removeSchedule(index),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Court Number
                      TextFormField(
                        controller: schedule.courtNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Court Number',
                          hintText: 'e.g., Court 1',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          schedule.courtNumber = value;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Date Picker
                      InkWell(
                        onTap: () => _pickDate(schedule),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                schedule.date != null
                                    ? '${schedule.date!.month}/${schedule.date!.day}/${schedule.date!.year}'
                                    : 'Select date',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Time Pickers
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickTime(schedule, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Time',
                                  border: OutlineInputBorder(),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      schedule.startTime != null
                                          ? schedule.startTime!.format(context)
                                          : 'Select',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const Icon(Icons.access_time, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickTime(schedule, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Time',
                                  border: OutlineInputBorder(),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      schedule.endTime != null
                                          ? schedule.endTime!.format(context)
                                          : 'Select',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const Icon(Icons.access_time, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetForm,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Reset Form'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveGame,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Save Game'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to manage schedule entry data
class _ScheduleEntry {
  final TextEditingController courtNumberController = TextEditingController();
  String courtNumber = '';
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  void dispose() {
    courtNumberController.dispose();
  }
}
