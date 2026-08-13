import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/condition.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/medication.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/patient.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/patient_history.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';

PatientProfileDemo mapPatientToProfile(
  Patient patient, {
  required int activeConditions,
  required int activeMedications,
  required int allergiesCount,
}) {
  return PatientProfileDemo(
    id: patient.id,
    fullName: '${patient.firstName} ${patient.lastName}'.trim(),
    dateOfBirth: patient.dateOfBirth,
    gender: parsePatientGender(patient.gender),
    bloodType: patient.bloodType,
    activeConditions: activeConditions,
    activeMedications: activeMedications,
    allergiesCount: allergiesCount,
  );
}

PatientProfileDemo mapHistoryToProfile(PatientHistory history) {
  final activeConditions = history.conditions.where((c) {
    final status = parseConditionStatus(c.status);
    return status == ConditionStatus.active ||
        status == ConditionStatus.chronic;
  }).length;

  final now = DateTime.now();
  final activeMedications = history.medications.where((m) {
    return m.endDate == null || m.endDate!.isAfter(now);
  }).length;

  return mapPatientToProfile(
    history.patient,
    activeConditions: activeConditions,
    activeMedications: activeMedications,
    allergiesCount: history.allergies.length,
  );
}

PatientProfileDemo mapSearchItemToProfile(
  PatientSearchItem patient, {
  int activeConditions = 0,
  int activeMedications = 0,
  int allergiesCount = 0,
}) {
  return PatientProfileDemo(
    id: patient.id,
    fullName: patient.fullName,
    dateOfBirth: patient.dateOfBirth,
    gender: patient.gender,
    bloodType: patient.bloodType,
    activeConditions: activeConditions,
    activeMedications: activeMedications,
    allergiesCount: allergiesCount,
  );
}

ConditionDemo mapConditionToDemo(Condition condition) {
  return ConditionDemo(
    id: condition.conditionId,
    name: condition.name,
    status: parseConditionStatus(condition.status),
    diagnosedDate: condition.diagnosedDate,
    notes: condition.notes,
  );
}

MedicationDemo mapMedicationToDemo(Medication medication) {
  return MedicationDemo(
    id: medication.medicationId,
    name: medication.name,
    dosage: medication.dosage,
    frequency: medication.frequency,
    prescriber: medication.prescribingDoctor,
    startDate: medication.startDate,
    endDate: medication.endDate,
  );
}

AllergyDemo mapAllergyToDemo(String allergy, {required int index}) {
  return AllergyDemo(id: 'A-$index', name: allergy);
}

ConditionStatus parseConditionStatus(String value) {
  switch (value.trim().toLowerCase()) {
    case 'chronic':
      return ConditionStatus.chronic;
    case 'resolved':
      return ConditionStatus.resolved;
    case 'active':
    default:
      return ConditionStatus.active;
  }
}

String conditionStatusToApi(ConditionStatus status) {
  switch (status) {
    case ConditionStatus.active:
      return 'Active';
    case ConditionStatus.chronic:
      return 'Chronic';
    case ConditionStatus.resolved:
      return 'Resolved';
  }
}
