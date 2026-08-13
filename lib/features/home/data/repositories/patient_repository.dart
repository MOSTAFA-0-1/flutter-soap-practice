import 'package:flutter_soap_practice/features/home/data/models/patient.dart';
import 'package:flutter_soap_practice/features/home/data/resources/patient_soap_resource.dart';

class PatientRepository {
  PatientRepository({required PatientSoapResource resource})
      : _resource = resource;

  final PatientSoapResource _resource;

  /// Calls [PatientSoapResource.searchPatients] and returns the mapped patients.
  Future<List<Patient>> searchPatients(String query) async {
    try {
      return await _resource.searchPatients(query);
    } catch (_) {
      throw Exception('Unable to search patients. Please try again.');
    }
  }
}
