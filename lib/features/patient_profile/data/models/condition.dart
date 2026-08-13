import 'package:xml/xml.dart';

/// Maps from a SOAP `<condition>` / `<Condition>` element.
class Condition {
  const Condition({
    required this.conditionId,
    required this.name,
    required this.diagnosedDate,
    required this.status,
    this.notes,
  });

  final String conditionId;
  final String name;
  final DateTime diagnosedDate;
  final String status;
  final String? notes;

  factory Condition.fromXml(XmlElement element) {
    final notesText = element.getElement('notes')?.innerText.trim();
    return Condition(
      conditionId: element.getElement('conditionId')?.innerText.trim() ?? '',
      name: element.getElement('name')?.innerText.trim() ?? '',
      diagnosedDate: DateTime.parse(
        element.getElement('diagnosedDate')?.innerText.trim() ?? '',
      ),
      status: element.getElement('status')?.innerText.trim() ?? '',
      notes: (notesText == null || notesText.isEmpty) ? null : notesText,
    );
  }

  String toXml() {
    final notesXml =
        notes == null || notes!.isEmpty ? '' : '<notes>${notes!}</notes>';
    return '''
<condition>
  <conditionId>$conditionId</conditionId>
  <name>$name</name>
  <diagnosedDate>${_formatDate(diagnosedDate)}</diagnosedDate>
  <status>$status</status>
  $notesXml
</condition>
''';
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
