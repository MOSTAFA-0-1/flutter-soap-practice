import 'package:xml/xml.dart';

/// Maps from a SOAP `<medication>` / `<Medication>` element.
class Medication {
  const Medication({
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.prescribingDoctor,
  });

  final String medicationId;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String prescribingDoctor;

  factory Medication.fromXml(XmlElement element) {
    final endDateText = element.getElement('endDate')?.innerText.trim();
    return Medication(
      medicationId: element.getElement('medicationId')?.innerText.trim() ?? '',
      name: element.getElement('name')?.innerText.trim() ?? '',
      dosage: element.getElement('dosage')?.innerText.trim() ?? '',
      frequency: element.getElement('frequency')?.innerText.trim() ?? '',
      startDate: DateTime.parse(
        element.getElement('startDate')?.innerText.trim() ?? '',
      ),
      endDate: (endDateText == null || endDateText.isEmpty)
          ? null
          : DateTime.parse(endDateText),
      prescribingDoctor:
          element.getElement('prescribingDoctor')?.innerText.trim() ?? '',
    );
  }

  String toXml() {
    final endDateXml =
        endDate == null ? '' : '<endDate>${_formatDate(endDate!)}</endDate>';
    return '''
<medication>
  <medicationId>$medicationId</medicationId>
  <name>$name</name>
  <dosage>$dosage</dosage>
  <frequency>$frequency</frequency>
  <startDate>${_formatDate(startDate)}</startDate>
  $endDateXml
  <prescribingDoctor>$prescribingDoctor</prescribingDoctor>
</medication>
''';
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
