import 'package:flutter/material.dart';

class PatientBannerStrip extends StatelessWidget {
  const PatientBannerStrip({
    super.key,
    required this.fullName,
    required this.patientId,
  });

  final String fullName;
  final String patientId;

  static const Color _bannerColor = Color(0xFFE8F1F8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: _bannerColor,
      child: Text(
        'Patient: $fullName ($patientId)',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
