import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/form_date_field.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/form_labeled_field.dart';

class AddMedicationFormCard extends StatelessWidget {
  const AddMedicationFormCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.dosageController,
    required this.frequencyController,
    required this.prescriberController,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.isSubmitting,
    required this.isEditing,
    required this.onSave,
    required this.onCancelEdit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController frequencyController;
  final TextEditingController prescriberController;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final bool isSubmitting;
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onCancelEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Edit Medication'
                          : 'Add New Medication',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isEditing)
                    TextButton(
                      onPressed: isSubmitting ? null : onCancelEdit,
                      child: const Text('Cancel'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              FormLabeledField(
                label: 'Medication Name *',
                controller: nameController,
                prefixIcon: Icons.medication_outlined,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Medication name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              FormLabeledField(
                label: 'Dosage * (e.g., 500mg, 10mg)',
                controller: dosageController,
                prefixIcon: Icons.straighten_outlined,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Dosage is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              FormLabeledField(
                label: 'Frequency * (e.g., Once daily, BID)',
                controller: frequencyController,
                prefixIcon: Icons.schedule_outlined,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Frequency is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              FormDateField(
                label: 'Start Date *',
                value: startDate,
                onChanged: onStartDateChanged,
                validator: (value) {
                  if (value == null) return 'Start date is required';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              FormDateField(
                label: 'End Date (Optional)',
                value: endDate,
                onChanged: onEndDateChanged,
                firstDate: startDate ?? DateTime(1900),
              ),
              const SizedBox(height: 14),
              FormLabeledField(
                label: 'Prescribing Doctor *',
                controller: prescriberController,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Prescribing doctor is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isSubmitting ? null : onSave,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isSubmitting
                        ? 'Saving...'
                        : isEditing
                            ? 'Update Medication'
                            : 'Save Medication',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
