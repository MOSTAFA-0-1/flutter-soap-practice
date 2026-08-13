import 'dart:developer';

import 'package:flutter_soap_practice/core/api/api_helper.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/condition.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/medication.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/patient_history.dart';
import 'package:xml/xml.dart';

/// SOAP data source for patient history reads and mutations.
class HistorySoapResource {
  HistorySoapResource({ApiHelper? apiHelper})
    : apiHelper = apiHelper ?? ApiHelper();

  final ApiHelper apiHelper;

  /// SOAPAction: `http://example.com/patient/GetPatientHistory`
  Future<PatientHistory> getPatientHistory(String patientId) async {
    try {
      final bodyInnerXml = '''
    <GetPatientHistoryRequest xmlns="http://example.com/patient">
      <patientId>2b953399-8ac6-4806-a4cf-177c0207afd7</patientId>
    </GetPatientHistoryRequest>
    ''';
      final responseXmlDocument = await apiHelper.postSoap(
        soapAction: 'GetPatientHistory',
        bodyInnerXml: bodyInnerXml,
      );
      final xmlElement = responseXmlDocument
          .findAllElements('GetPatientHistoryResponse', namespaceUri: '*')
          .firstOrNull;
      if (xmlElement == null) {
        log(
          'GetPatientHistoryResponse not found',
          name: 'HistorySoapResource',
        );
        throw Exception('GetPatientHistoryResponse not found');
      }
      final historyElement =
          xmlElement.getElement('history', namespaceUri: '*') ?? xmlElement;
      return PatientHistory.fromXml(historyElement);
    } catch (e, st) {
      log(
        'getPatientHistory failed: $e',
        name: 'HistorySoapResource',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// SOAPAction: `http://example.com/patient/AddCondition`
  Future<bool> addCondition(String patientId, Condition condition) async {
    try {
      final bodyInnerXml = '''
      <AddConditionRequest>
        <patientId>$patientId</patientId>
        ${condition.toXml()}
      </AddConditionRequest>
  ''';
      final responseXmlDocument = await apiHelper.postSoap(
        soapAction: 'AddCondition',
        bodyInnerXml: bodyInnerXml,
      );
      final xmlElement = responseXmlDocument
          .findAllElements('AddConditionResponse', namespaceUri: '*')
          .firstOrNull;
      if (xmlElement == null) {
        log('AddConditionResponse not found', name: 'HistorySoapResource');
        throw Exception('AddConditionResponse not found');
      }
      final successText =
          xmlElement.getElement('success')?.innerText.trim().toLowerCase();
      return successText == 'true' || xmlElement.getAttribute('success') == 'true';
    } catch (e, st) {
      log(
        'addCondition failed: $e',
        name: 'HistorySoapResource',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// SOAPAction: `http://example.com/patient/UpdateMedication`
  Future<bool> updateMedication(
    String patientId,
    Medication medication,
  ) async {
    try {
      final bodyInnerXml = '''
      <UpdateMedicationRequest>
        <patientId>$patientId</patientId>
        ${medication.toXml()}
      </UpdateMedicationRequest>
  ''';
      final responseXmlDocument = await apiHelper.postSoap(
        soapAction: 'UpdateMedication',
        bodyInnerXml: bodyInnerXml,
      );
      final xmlElement = responseXmlDocument
          .findAllElements('UpdateMedicationResponse', namespaceUri: '*')
          .firstOrNull;
      if (xmlElement == null) {
        log(
          'UpdateMedicationResponse not found',
          name: 'HistorySoapResource',
        );
        throw Exception('UpdateMedicationResponse not found');
      }
      final successText =
          xmlElement.getElement('success')?.innerText.trim().toLowerCase();
      return successText == 'true' || xmlElement.getAttribute('success') == 'true';
    } catch (e, st) {
      log(
        'updateMedication failed: $e',
        name: 'HistorySoapResource',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
