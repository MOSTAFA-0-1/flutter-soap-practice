import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

class HistoryMiniHeader extends StatelessWidget {
  const HistoryMiniHeader({super.key, required this.profile});

  final PatientProfileDemo profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      child: Text(
        '${profile.fullName}  ·  ${profile.id}  ·  DOB: ${profile.formattedDob}  ·  ${profile.genderLabel}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
