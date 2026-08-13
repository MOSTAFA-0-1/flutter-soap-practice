class SoapConfig {
  SoapConfig._();

  static const String baseUrl = 'your_base_url';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'text/xml; charset=utf-8',
  };
}
