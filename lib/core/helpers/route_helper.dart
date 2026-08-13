import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/home/ui/screens/patient_search_screen.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/patient_history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/add_condition_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/manage_medications_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/medical_history_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_profile_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/screens/add_condition_screen.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/screens/manage_medications_screen.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/screens/medical_history_screen.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/screens/patient_profile_screen.dart';

class RouteHelper {
  RouteHelper._();

  static const String patientSearch = '/';
  static const String patientProfile = '/patient-profile';
  static const String medicalHistory = '/medical-history';
  static const String addCondition = '/add-condition';
  static const String manageMedications = '/manage-medications';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case patientSearch:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PatientSearchScreen(),
        );
      case patientProfile:
        return _patientRoute(
          settings,
          (context, patient) => ChangeNotifierProvider(
            create: (context) => PatientProfileController(
              patient: patient,
              historyRepository: context.read<PatientHistoryRepository>(),
            ),
            child: const PatientProfileScreen(),
          ),
        );
      case medicalHistory:
        return _patientRoute(
          settings,
          (context, patient) => ChangeNotifierProvider(
            create: (context) => MedicalHistoryController(
              patient: patient,
              historyRepository: context.read<PatientHistoryRepository>(),
            ),
            child: const MedicalHistoryScreen(),
          ),
        );
      case addCondition:
        return _patientRoute(
          settings,
          (context, patient) => ChangeNotifierProvider(
            create: (context) => AddConditionController(
              patient: patient,
              historyRepository: context.read<HistoryRepository>(),
            ),
            child: const AddConditionScreen(),
          ),
        );
      case manageMedications:
        return _patientRoute(
          settings,
          (context, patient) => ChangeNotifierProvider(
            create: (context) => ManageMedicationsController(
              patient: patient,
              historyRepository: context.read<PatientHistoryRepository>(),
              mutationRepository: context.read<HistoryRepository>(),
            ),
            child: const ManageMedicationsScreen(),
          ),
        );
      default:
        return null;
    }
  }

  static Future<void> toPatientProfile(
    BuildContext context,
    PatientSearchItem patient,
  ) {
    return Navigator.of(context).pushNamed(
      patientProfile,
      arguments: patient,
    );
  }

  static Future<void> toMedicalHistory(
    BuildContext context,
    PatientSearchItem patient,
  ) {
    return Navigator.of(context).pushNamed(
      medicalHistory,
      arguments: patient,
    );
  }

  static Future<void> toAddCondition(
    BuildContext context,
    PatientSearchItem patient,
  ) {
    return Navigator.of(context).pushNamed(
      addCondition,
      arguments: patient,
    );
  }

  static Future<void> toManageMedications(
    BuildContext context,
    PatientSearchItem patient,
  ) {
    return Navigator.of(context).pushNamed(
      manageMedications,
      arguments: patient,
    );
  }

  static MaterialPageRoute<void> _patientRoute(
    RouteSettings settings,
    Widget Function(BuildContext context, PatientSearchItem patient) builder,
  ) {
    final patient = settings.arguments as PatientSearchItem;
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => builder(context, patient),
    );
  }
}
