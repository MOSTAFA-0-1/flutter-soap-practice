import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

class AllergyChips extends StatelessWidget {
  const AllergyChips({super.key, required this.allergies});

  final List<AllergyDemo> allergies;

  @override
  Widget build(BuildContext context) {
    if (allergies.isEmpty) {
      return Text(
        'No known allergies',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final allergy in allergies)
          Chip(
            label: Text(allergy.name),
            backgroundColor: Colors.red.shade50,
            side: BorderSide(color: Colors.red.shade100),
            labelStyle: TextStyle(
              color: Colors.red.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
