import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/core/helpers/route_helper.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/home/ui/widgets/patient_card.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key, required this.patients});

  final List<PatientSearchItem> patients;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: patients.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return PatientCard(
          patient: patient,
          onTap: () {
            RouteHelper.toPatientProfile(context, patient);
          },
        );
      },
    );
  }
}
