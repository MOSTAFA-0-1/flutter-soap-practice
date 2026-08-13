import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

class FormStatusDropdown extends StatelessWidget {
  const FormStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final ConditionStatus? value;
  final ValueChanged<ConditionStatus?> onChanged;
  final String? Function(ConditionStatus?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status *',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<ConditionStatus>(
          // ignore: deprecated_member_use
          value: value,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.flag_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          hint: const Text('Select status'),
          items: ConditionStatus.values
              .map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(_labelFor(status)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _labelFor(ConditionStatus status) {
    switch (status) {
      case ConditionStatus.active:
        return 'Active';
      case ConditionStatus.resolved:
        return 'Resolved';
      case ConditionStatus.chronic:
        return 'Chronic';
    }
  }
}
