import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/core/helpers/route_helper.dart';
import 'package:flutter_soap_practice/features/home/data/repositories/patient_repository.dart';
import 'package:flutter_soap_practice/features/home/data/resources/patient_soap_resource.dart';
import 'package:flutter_soap_practice/features/home/ui/controllers/patient_search_controller.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/patient_history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/resources/history_soap_resource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final patientSoapResource = PatientSoapResource();
    final historySoapResource = HistorySoapResource();
    final patientRepository =
        PatientRepository(resource: patientSoapResource);
    final historyRepository =
        HistoryRepository(resource: historySoapResource);
    final patientHistoryRepository =
        PatientHistoryRepository(resource: historySoapResource);

    return MultiProvider(
      providers: [
        Provider<PatientRepository>.value(value: patientRepository),
        Provider<HistoryRepository>.value(value: historyRepository),
        Provider<PatientHistoryRepository>.value(
          value: patientHistoryRepository,
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PatientSearchController(repository: patientRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Patient Records',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: RouteHelper.patientSearch,
        onGenerateRoute: RouteHelper.onGenerateRoute,
      ),
    );
  }
}
