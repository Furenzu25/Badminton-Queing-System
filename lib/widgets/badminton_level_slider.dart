import 'package:flutter/material.dart';
import '../models/badminton_level.dart';

/// Custom slider widget for selecting badminton skill level range
/// Allows selection of min/max level and strength within each level
class BadmintonLevelSlider extends StatefulWidget {
  final BadmintonLevel initialMinLevel;
  final SkillStrength initialMinStrength;
  final BadmintonLevel initialMaxLevel;
  final SkillStrength initialMaxStrength;
  final Function(BadmintonLevel, SkillStrength, BadmintonLevel, SkillStrength)
  onChanged;

  const BadmintonLevelSlider({
    super.key,
    required this.initialMinLevel,
    required this.initialMinStrength,
    required this.initialMaxLevel,
    required this.initialMaxStrength,
    required this.onChanged,
  });

  @override
  State<BadmintonLevelSlider> createState() => _BadmintonLevelSliderState();
}

class _BadmintonLevelSliderState extends State<BadmintonLevelSlider> {
  late double _minValue;
  late double _maxValue;

  @override
  void initState() {
    super.initState();
    _minValue = _getLevelValue(
      widget.initialMinLevel,
      widget.initialMinStrength,
    );
    _maxValue = _getLevelValue(
      widget.initialMaxLevel,
      widget.initialMaxStrength,
    );
  }

  /// Convert level and strength to a continuous value (0-20)
  /// Each level has 3 positions (weak, mid, strong)
  double _getLevelValue(BadmintonLevel level, SkillStrength strength) {
    return (level.index * 3 + strength.index).toDouble();
  }

  /// Convert continuous value back to level and strength
  (BadmintonLevel, SkillStrength) _getFromValue(double value) {
    final intValue = value.toInt();
    final levelIndex = intValue ~/ 3;
    final strengthIndex = intValue % 3;

    return (
      BadmintonLevel.fromIndex(levelIndex),
      SkillStrength.fromIndex(strengthIndex),
    );
  }

  /// Get label for a specific value
  String _getLabel(double value) {
    final (level, strength) = _getFromValue(value);
    return '${level.displayName}\n${strength.displayName}';
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = (BadmintonLevel.values.length * 3 - 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display current selection
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MIN', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      _getLabel(_minValue).replaceAll('\n', ' '),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: Theme.of(context).iconTheme.color,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('MAX', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      _getLabel(_maxValue).replaceAll('\n', ' '),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Range slider
        RangeSlider(
          values: RangeValues(_minValue, _maxValue),
          min: 0,
          max: maxValue,
          divisions: maxValue.toInt(),
          labels: RangeLabels(_getLabel(_minValue), _getLabel(_maxValue)),
          onChanged: (RangeValues values) {
            setState(() {
              _minValue = values.start;
              _maxValue = values.end;
            });

            final (minLevel, minStrength) = _getFromValue(_minValue);
            final (maxLevel, maxStrength) = _getFromValue(_maxValue);

            widget.onChanged(minLevel, minStrength, maxLevel, maxStrength);
          },
        ),
        // Level labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: BadmintonLevel.values.map((level) {
              return Flexible(
                child: Text(
                  level.displayName,
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
