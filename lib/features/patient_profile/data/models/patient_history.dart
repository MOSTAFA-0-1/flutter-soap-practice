import 'package:flutter_soap_practice/features/patient_profile/data/models/condition.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/medication.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/patient.dart';
import 'package:xml/xml.dart';

/// Wrapper for `<history>` / `<PatientHistory>` SOAP payload.
class PatientHistory {
  const PatientHistory({
    required this.patient,
    required this.conditions,
    required this.medications,
    required this.allergies,
  });

  final Patient patient;
  final List<Condition> conditions;
  final List<Medication> medications;
  final List<String> allergies;

  factory PatientHistory.fromXml(XmlElement historyElement) {
    final patientElement = historyElement.getElement('patient');
    if (patientElement == null) {
      throw Exception('Patient history is missing patient data.');
    }

    final conditionsParent = historyElement.getElement('conditions');
    final medicationsParent = historyElement.getElement('medications');
    final allergiesParent = historyElement.getElement('allergies');

    final conditions = conditionsParent == null
        ? const <Condition>[]
        : conditionsParent
            .findElements('condition')
            .map(Condition.fromXml)
            .toList(growable: false);

    final medications = medicationsParent == null
        ? const <Medication>[]
        : medicationsParent
            .findElements('medication')
            .map(Medication.fromXml)
            .toList(growable: false);

    final allergies = allergiesParent == null
        ? const <String>[]
        : allergiesParent.childElements
            .map((e) => e.innerText.trim())
            .where((text) => text.isNotEmpty)
            .toList(growable: false);

    return PatientHistory(
      patient: Patient.fromXml(patientElement),
      conditions: conditions,
      medications: medications,
      allergies: allergies,
    );
  }
}
