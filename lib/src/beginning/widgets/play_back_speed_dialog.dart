import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';

class PlaybackSpeedSelector extends StatefulWidget {
  final double currentSpeed;
  final Function(double) onSpeedSelected;

  const PlaybackSpeedSelector({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  @override
  State<PlaybackSpeedSelector> createState() => _PlaybackSpeedSelectorState();
}

class _PlaybackSpeedSelectorState extends State<PlaybackSpeedSelector> {
  final List<double> speeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];

  // Speed options
  late double _currentValue = widget.currentSpeed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Playback Speed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text("${_currentValue.toStringAsFixed(2)}x"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (_currentValue > .35) {
                          setState(() {
                            _currentValue = _currentValue - .1;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  SizedBox(
                    width: deviceWidth! / 1.5,
                    child: Slider(
                      value: _currentValue,
                      min: 0.25,
                      max: 2.0,
                      activeColor: Colors.lightBlue,
                      divisions: 10,
                      onChanged: (value) {
                        _currentValue = value;
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (_currentValue < 1.9) {
                          setState(() {
                            _currentValue = _currentValue + .1;
                          });
                        }
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              if (_currentValue != widget.currentSpeed)
                ElevatedButton(
                  onPressed: () {
                    try {
                      double value =
                          double.parse(_currentValue.toStringAsFixed(2));
                      if (value != widget.currentSpeed) {
                        widget.onSpeedSelected(value);
                      }
                    } catch (_) {}
                  },
                  child: const Text("OK"),
                )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50, // Fixed height for the horizontal list
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: speeds.map((label) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text("${label}x"),
                    selectedColor: Colors.blue.shade100,
                    selected: playbackSpeed == label,
                    onSelected: (value) {
                      if (value) widget.onSpeedSelected(label);
                    },
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
