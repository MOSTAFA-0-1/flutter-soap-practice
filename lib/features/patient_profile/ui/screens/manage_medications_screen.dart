import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/manage_medications_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/add_medication_form_card.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/medication_manage_card.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/patient_banner_strip.dart';

class ManageMedicationsScreen extends StatefulWidget {
  const ManageMedicationsScreen({super.key});

  @override
  State<ManageMedicationsScreen> createState() =>
      _ManageMedicationsScreenState();
}

class _ManageMedicationsScreenState extends State<ManageMedicationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _prescriberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _prescriberController.dispose();
    super.dispose();
  }

  void _clearTextFields() {
    _nameController.clear();
    _dosageController.clear();
    _frequencyController.clear();
    _prescriberController.clear();
  }

  void _onEdit(String id) {
    final med = context.read<ManageMedicationsController>().beginEdit(id);
    if (med == null) return;
    _nameController.text = med.name;
    _dosageController.text = med.dosage;
    _frequencyController.text = med.frequency;
    _prescriberController.text = med.prescriber;
  }

  void _onCancelEdit() {
    context.read<ManageMedicationsController>().clearFormDates();
    _clearTextFields();
    _formKey.currentState?.reset();
  }

  Future<void> _onDelete(String id, String label) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text('Remove $label from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final controller = context.read<ManageMedicationsController>();
    final wasEditing = controller.editingId == id;
    controller.deleteMedication(id);
    if (wasEditing) {
      _clearTextFields();
      _formKey.currentState?.reset();
    }
  }

  Future<void> _onSave() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final controller = context.read<ManageMedicationsController>();
    final wasEditing = controller.isEditing;
    final ok = await controller.saveMedication(
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      frequency: _frequencyController.text.trim(),
      prescriber: _prescriberController.text.trim(),
    );
    if (!mounted) return;

    if (!ok) {
      final message = controller.error ?? 'Unable to save medication';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    _clearTextFields();
    _formKey.currentState?.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasEditing ? 'Medication updated' : 'Medication saved',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ManageMedicationsController>();
    final profile = controller.profile;
    final medications = controller.medications;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medications'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PatientBannerStrip(
            fullName: profile.fullName,
            patientId: profile.id,
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (controller.error != null) ...[
                        Text(
                          controller.error!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        'Current Medications',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (medications.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No medications yet.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        ...medications.map(
                          (med) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MedicationManageCard(
                              medication: med,
                              onEdit: () => _onEdit(med.id),
                              onDelete: () =>
                                  _onDelete(med.id, med.nameWithDosage),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 12),
                      AddMedicationFormCard(
                        formKey: _formKey,
                        nameController: _nameController,
                        dosageController: _dosageController,
                        frequencyController: _frequencyController,
                        prescriberController: _prescriberController,
                        startDate: controller.startDate,
                        endDate: controller.endDate,
                        onStartDateChanged: controller.setStartDate,
                        onEndDateChanged: controller.setEndDate,
                        isSubmitting: controller.isSubmitting,
                        isEditing: controller.isEditing,
                        onSave: _onSave,
                        onCancelEdit: _onCancelEdit,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
