import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_soap_practice/features/home/ui/controllers/patient_search_controller.dart';
import 'package:flutter_soap_practice/features/home/ui/widgets/empty_patients_view.dart';
import 'package:flutter_soap_practice/features/home/ui/widgets/patient_list_view.dart';
import 'package:flutter_soap_practice/features/home/ui/widgets/patient_search_bar.dart';

class PatientSearchScreen extends StatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PatientSearchController>();
    final patients = controller.filteredPatients;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Records',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: PatientSearchBar(
              controller: _searchController,
              onChanged: (value) {
                context.read<PatientSearchController>().updateQuery(value);
              },
              onSearch: () {
                context.read<PatientSearchController>().search();
              },
            ),
          ),
          if (controller.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                controller.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : patients.isEmpty
                    ? const EmptyPatientsView()
                    : PatientListView(patients: patients),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Future: add new patient
        },
        tooltip: 'Add patient',
        child: const Icon(Icons.add),
      ),
    );
  }
}
