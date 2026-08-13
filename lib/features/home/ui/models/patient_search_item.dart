import 'package:flutter_soap_practice/features/home/data/models/patient.dart';

enum PatientGender { male, female }

/// UI presentation model for a patient search result.
class PatientSearchItem {
  const PatientSearchItem({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
  });

  final String id;
  final String fullName;
  final DateTime dateOfBirth;
  final PatientGender gender;
  final String bloodType;

  factory PatientSearchItem.fromPatient(Patient patient) {
    return PatientSearchItem(
      id: patient.id,
      fullName: '${patient.firstName} ${patient.lastName}'.trim(),
      dateOfBirth: patient.dateOfBirth,
      gender: parsePatientGender(patient.gender),
      bloodType: patient.bloodType,
    );
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get formattedDob {
    final y = dateOfBirth.year.toString().padLeft(4, '0');
    final m = dateOfBirth.month.toString().padLeft(2, '0');
    final d = dateOfBirth.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

PatientGender parsePatientGender(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.startsWith('f') || normalized == 'female') {
    return PatientGender.female;
  }
  return PatientGender.male;
}
