import 'package:flutter/material.dart';
class SegmentButton extends StatelessWidget {
  final Set<String> selected;
  final List<Segment> segments;
  final ValueChanged<Set<String>> onSelectionChanged;

  const SegmentButton({super.key,
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ToggleButtons(
        isSelected: segments.map((segment) => selected.contains(segment.value)).toList(),
        onPressed: (index) {
          onSelectionChanged({segments[index].value});
        },
        children: segments.map((segment) => segment.label ?? Container()).toList(),
      ),
    );
  }
}

class Segment {
  final String value;
  final Widget? label;

  const Segment({
    required this.value,
    required this.label,
  });
}