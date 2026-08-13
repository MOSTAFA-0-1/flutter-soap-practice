import 'package:flutter/material.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';

class GenderIndicator extends StatelessWidget {
  const GenderIndicator({super.key, required this.gender});

  final PatientGender gender;

  @override
  Widget build(BuildContext context) {
    final isMale = gender == PatientGender.male;
    return Text(
      isMale ? '♂' : '♀',
      style: TextStyle(
        fontSize: 18,
        color: isMale ? Colors.blue.shade700 : Colors.pink.shade600,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
