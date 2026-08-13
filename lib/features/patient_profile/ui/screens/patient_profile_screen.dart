import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/core/helpers/route_helper.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_profile_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/profile_action_buttons.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/profile_header_card.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/profile_stats_row.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  void _openHistory(BuildContext context) {
    final patient = context.read<PatientProfileController>().patient;
    RouteHelper.toMedicalHistory(context, patient);
  }

  void _openAddCondition(BuildContext context) {
    final patient = context.read<PatientProfileController>().patient;
    RouteHelper.toAddCondition(context, patient);
  }

  void _openMedications(BuildContext context) {
    final patient = context.read<PatientProfileController>().patient;
    RouteHelper.toManageMedications(context, patient);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PatientProfileController>();
    final profile = controller.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.isLoading
                ? null
                : () {
                    context.read<PatientProfileController>().refresh();
                  },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                if (controller.error != null) ...[
                  Text(
                    controller.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ProfileHeaderCard(profile: profile),
                const SizedBox(height: 16),
                ProfileStatsRow(profile: profile),
                const SizedBox(height: 16),
                ProfileActionButtons(
                  onFullHistory: () => _openHistory(context),
                  onAddCondition: () => _openAddCondition(context),
                  onMedications: () => _openMedications(context),
                ),
              ],
            ),
    );
  }
}
