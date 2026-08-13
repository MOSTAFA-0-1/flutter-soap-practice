import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';

enum ConditionStatus { active, chronic, resolved }

enum HistoryFilter { all, active, resolved, chronic }

/// UI presentation model for the patient profile header/stats.
class PatientProfileDemo {
  const PatientProfileDemo({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.activeConditions,
    required this.activeMedications,
    required this.allergiesCount,
  });

  final String id;
  final String fullName;
  final DateTime dateOfBirth;
  final PatientGender gender;
  final String bloodType;
  final int activeConditions;
  final int activeMedications;
  final int allergiesCount;

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

  int get age {
    final now = DateTime.now();
    var years = now.year - dateOfBirth.year;
    final hadBirthday = now.month > dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);
    if (!hadBirthday) years -= 1;
    return years;
  }

  String get genderLabel => gender == PatientGender.male ? 'Male' : 'Female';
}

class ConditionDemo {
  const ConditionDemo({
    required this.id,
    required this.name,
    required this.status,
    required this.diagnosedDate,
    this.notes,
  });

  final String id;
  final String name;
  final ConditionStatus status;
  final DateTime diagnosedDate;
  final String? notes;

  String get formattedDiagnosedDate {
    final y = diagnosedDate.year.toString().padLeft(4, '0');
    final m = diagnosedDate.month.toString().padLeft(2, '0');
    final d = diagnosedDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get statusLabel {
    switch (status) {
      case ConditionStatus.active:
        return 'Active';
      case ConditionStatus.chronic:
        return 'Chronic';
      case ConditionStatus.resolved:
        return 'Resolved';
    }
  }
}

class MedicationDemo {
  const MedicationDemo({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.prescriber,
    required this.startDate,
    this.endDate,
  });

  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String prescriber;
  final DateTime startDate;
  final DateTime? endDate;

  String get nameWithDosage => '$name $dosage';

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get dateRangeLabel {
    final start = _formatDate(startDate);
    final end = endDate == null ? 'Current' : _formatDate(endDate!);
    return '$start → $end';
  }
}

class AllergyDemo {
  const AllergyDemo({required this.id, required this.name});

  final String id;
  final String name;
}
