import 'package:flutter_soap_practice/features/patient_profile/data/models/patient_history.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/resources/history_soap_resource.dart';

class PatientHistoryRepository {
  PatientHistoryRepository({required HistorySoapResource resource})
      : _resource = resource;

  final HistorySoapResource _resource;

  /// Calls [HistorySoapResource.getPatientHistory] and returns the mapped history.
  Future<PatientHistory> getPatientHistory(String patientId) async {
    try {
      return await _resource.getPatientHistory(patientId);
    } catch (_) {
      throw Exception('Unable to load patient history. Please try again.');
    }
  }
}
