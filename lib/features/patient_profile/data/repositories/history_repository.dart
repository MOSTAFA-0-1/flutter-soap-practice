import 'package:flutter_soap_practice/features/patient_profile/data/models/condition.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/medication.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/resources/history_soap_resource.dart';

class HistoryRepository {
  HistoryRepository({required HistorySoapResource resource})
      : _resource = resource;

  final HistorySoapResource _resource;

  /// Calls [HistorySoapResource.addCondition] and returns the success flag.
  Future<bool> addCondition(String patientId, Condition condition) async {
    try {
      return await _resource.addCondition(patientId, condition);
    } catch (_) {
      throw Exception('Unable to add condition. Please try again.');
    }
  }

  /// Calls [HistorySoapResource.updateMedication] and returns the success flag.
  Future<bool> updateMedication(
    String patientId,
    Medication medication,
  ) async {
    try {
      return await _resource.updateMedication(patientId, medication);
    } catch (_) {
      throw Exception('Unable to update medication. Please try again.');
    }
  }
}
