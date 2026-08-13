import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.profile});

  final PatientProfileDemo profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            value: '${profile.activeConditions}',
            label: 'Active Conditions',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            value: '${profile.activeMedications}',
            label: 'Active Medications',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            value: '${profile.allergiesCount}',
            label: 'Allergies',
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
