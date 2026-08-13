import 'package:xml/xml.dart';

/// Maps from a SOAP `<patient>` / `<Patient>` element.
class Patient {
  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
  });

  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodType;

  factory Patient.fromXml(XmlElement element) {
    return Patient(
      id: element.getElement('id')?.innerText.trim() ?? '',
      firstName: element.getElement('firstName')?.innerText.trim() ?? '',
      lastName: element.getElement('lastName')?.innerText.trim() ?? '',
      dateOfBirth: DateTime.parse(
        element.getElement('dateOfBirth')?.innerText.trim() ?? '',
      ),
      gender: element.getElement('gender')?.innerText.trim() ?? '',
      bloodType: element.getElement('bloodType')?.innerText.trim() ?? '',
    );
  }
}
