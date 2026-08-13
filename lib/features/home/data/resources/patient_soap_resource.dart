import 'dart:developer';

import 'package:flutter_soap_practice/core/api/api_helper.dart';
import 'package:flutter_soap_practice/features/home/data/models/patient.dart';
import 'package:xml/xml.dart';

/// SOAP data source for patient search.
///
/// Method bodies are intentionally omitted — implement against [SoapConfig].
class PatientSoapResource {
  final ApiHelper apiHelper = ApiHelper();

  /// SOAPAction: `http://example.com/patient/SearchPatients`
  ///
  /// Request body: `<SearchPatientsRequest>` with `<searchTerm>` and optional
  /// `<maxResults>`.
  ///
  /// Response: `<SearchPatientsResponse>` containing `<patient>` elements,
  /// mapped to [Patient] models.
  Future<List<Patient>> searchPatients(
    String searchTerm, {
    int maxResults = 20,
  }) async {
    try {
      final bodyInnerXml =
          '''
    <SearchPatientsRequest>
      <searchTerm>$searchTerm</searchTerm>
      <maxResults>$maxResults</maxResults>
    </SearchPatientsRequest>
    ''';
      final responseXmlDocument = await apiHelper.postSoap(
        soapAction: "SearchPatients",
        bodyInnerXml: bodyInnerXml,
      );
      final xmlelment = responseXmlDocument
          .findAllElements('SearchPatientsResponse', namespaceUri: '*')
          .firstOrNull;
      if (xmlelment == null) {
        log('SearchPatientsResponse not found', name: 'PatientSoapResource');
        throw Exception('SearchPatientsResponse not found');
      }
      return xmlelment
          .findAllElements('patients')
          .map((e) => Patient.fromXml(e))
          .toList();
    } catch (e, st) {
      log(
        'searchPatients failed: $e',
        name: 'PatientSoapResource',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
