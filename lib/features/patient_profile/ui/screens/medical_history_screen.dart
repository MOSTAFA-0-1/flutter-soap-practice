import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/medical_history_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/allergy_chips.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/condition_expandable_card.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/condition_filter_tabs.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/history_mini_header.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/widgets/medication_list_item.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MedicalHistoryController>();
    final profile = controller.profile;
    final conditions = controller.filteredConditions;
    final medications = controller.medications;
    final allergies = controller.allergies;

    return Scaffold(
      appBar: AppBar(
        title: Text('${profile.fullName} - History'),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                HistoryMiniHeader(profile: profile),
                if (controller.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      controller.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ConditionFilterTabs(
                  selected: controller.filter,
                  onChanged:
                      context.read<MedicalHistoryController>().setFilter,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Text(
                        '🩺 Conditions (${conditions.length})',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10),
                      if (conditions.isEmpty)
                        Text(
                          'No conditions for this filter.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        )
                      else
                        ...[
                          for (var i = 0; i < conditions.length; i++) ...[
                            ConditionExpandableCard(condition: conditions[i]),
                            if (i < conditions.length - 1)
                              const SizedBox(height: 8),
                          ],
                        ],
                      const SizedBox(height: 24),
                      Text(
                        '💊 Medications (${medications.length})',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10),
                      for (var i = 0; i < medications.length; i++) ...[
                        MedicationListItem(medication: medications[i]),
                        if (i < medications.length - 1)
                          const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        '⚠️ Allergies',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10),
                      AllergyChips(allergies: allergies),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
