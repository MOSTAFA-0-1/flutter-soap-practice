import 'package:flutter/material.dart';

class PatientAvatar extends StatelessWidget {
  const PatientAvatar({
    super.key,
    required this.initials,
    this.radius = 24,
  });

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
