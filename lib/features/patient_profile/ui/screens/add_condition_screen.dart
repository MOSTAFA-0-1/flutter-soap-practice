import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/add_condition_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/form_date_field.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/form_labeled_field.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/form_status_dropdown.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/patient_banner_strip.dart';

class AddConditionScreen extends StatefulWidget {
  const AddConditionScreen({super.key});

  @override
  State<AddConditionScreen> createState() => _AddConditionScreenState();
}

class _AddConditionScreenState extends State<AddConditionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final controller = context.read<AddConditionController>();
    final ok = await controller.submit(
      name: _nameController.text.trim(),
      notes: _notesController.text.trim(),
    );
    if (!mounted) return;

    if (!ok) {
      final message = controller.error ?? 'Unable to save condition';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Condition saved')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddConditionController>();
    final profile = controller.profile;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Condition'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PatientBannerStrip(
            fullName: profile.fullName,
            patientId: profile.id,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  FormLabeledField(
                    label: 'Condition Name *',
                    controller: _nameController,
                    prefixIcon: Icons.medical_information_outlined,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Condition name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormDateField(
                    label: 'Diagnosed Date *',
                    value: controller.diagnosedDate,
                    onChanged: controller.setDiagnosedDate,
                    lastDate: DateTime.now(),
                    validator: (value) {
                      if (value == null) {
                        return 'Diagnosed date is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormStatusDropdown(
                    value: controller.status,
                    onChanged: controller.setStatus,
                    validator: (value) {
                      if (value == null) {
                        return 'Status is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormLabeledField(
                    label: 'Notes (Optional)',
                    controller: _notesController,
                    prefixIcon: Icons.notes_outlined,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: controller.isSubmitting ? null : _onSave,
                      icon: controller.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        controller.isSubmitting
                            ? 'Saving...'
                            : 'Save Condition',
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'All fields with * are required',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
