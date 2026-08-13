import 'dart:developer';

import 'package:flutter_soap_practice/core/soap/soap_config.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

/// Shared HTTP helpers for SOAP XML requests.
class ApiHelper {
  ApiHelper({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Builds a SOAP 1.1 envelope around the given body XML fragment.
  String buildSoapEnvelope(String bodyInnerXml) {
    return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    $bodyInnerXml
  </soap:Body>
</soap:Envelope>
''';
  }

  /// POSTs a SOAP request to [SoapConfig.baseUrl] and returns the parsed XML.
  Future<XmlDocument> postSoap({
    required String soapAction,
    required String bodyInnerXml,
    Map<String, String>? extraHeaders,
  }) async {
    final envelope = buildSoapEnvelope(bodyInnerXml);
    final headers = <String, String>{
      ...SoapConfig.defaultHeaders,
      'SOAPAction': soapAction,
      if (extraHeaders != null) ...extraHeaders,
    };

    log(
      'SOAP request [$soapAction] -> ${SoapConfig.baseUrl}\n'
      'headers: $headers\n'
      '$envelope',
      name: 'ApiHelper',
    );

    final response = await _client.post(
      Uri.parse(SoapConfig.baseUrl),
      headers: headers,
      body: envelope,
    );

    return _parseResponse(response);
  }

  /// POSTs raw XML (already a full envelope or document) to [SoapConfig.baseUrl].
  Future<XmlDocument> postXml({
    required String soapAction,
    required String xmlBody,
    Map<String, String>? extraHeaders,
  }) async {
    final headers = <String, String>{
      ...SoapConfig.defaultHeaders,
      'SOAPAction': soapAction,
      if (extraHeaders != null) ...extraHeaders,
    };

    log(
      'SOAP request [$soapAction] -> ${SoapConfig.baseUrl}\n'
      'headers: $headers\n'
      '$xmlBody',
      name: 'ApiHelper',
    );

    final response = await _client.post(
      Uri.parse(SoapConfig.baseUrl),
      headers: headers,
      body: xmlBody,
    );

    return _parseResponse(response);
  }

  XmlDocument _parseResponse(http.Response response) {
    log(
      'SOAP response [${response.statusCode}]\n${response.body}',
      name: 'ApiHelper',
    );

    if (response.statusCode < 200) {
      log(
        'SOAP request failed with status ${response.statusCode}.\n'
        '${response.body}',
        name: 'ApiHelper',
      );
      throw Exception(
        'SOAP request failed with status ${response.statusCode}.',
      );
    }

    final document = XmlDocument.parse(response.body);
    final faults = document.findAllElements('Fault', namespaceUri: '*');
    if (faults.isNotEmpty) {
      final message = faults.first.innerText.trim();
      final faultMessage =
          message.isEmpty ? 'SOAP Fault received from server.' : message;
      log('SOAP Fault: $faultMessage', name: 'ApiHelper');
      throw Exception(faultMessage);
    }

    return document;
  }

  void dispose() {
    _client.close();
  }
}
