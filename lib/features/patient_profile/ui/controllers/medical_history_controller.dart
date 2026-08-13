import 'package:flutter/foundation.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/patient_history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/mappers/history_ui_mapper.dart';

class MedicalHistoryController extends ChangeNotifier {
  MedicalHistoryController({
    required PatientSearchItem patient,
    required PatientHistoryRepository historyRepository,
  })  : _patient = patient,
        _historyRepository = historyRepository,
        _profile = mapSearchItemToProfile(patient) {
    load();
  }

  final PatientSearchItem _patient;
  final PatientHistoryRepository _historyRepository;

  PatientProfileDemo _profile;
  List<ConditionDemo> _conditions = const [];
  List<MedicationDemo> _medications = const [];
  List<AllergyDemo> _allergies = const [];
  HistoryFilter _filter = HistoryFilter.all;
  bool _isLoading = true;
  String? _error;

  PatientSearchItem get patient => _patient;
  PatientProfileDemo get profile => _profile;
  List<MedicationDemo> get medications => _medications;
  List<AllergyDemo> get allergies => _allergies;
  HistoryFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ConditionDemo> get filteredConditions {
    switch (_filter) {
      case HistoryFilter.all:
        return _conditions;
      case HistoryFilter.active:
        return _conditions
            .where((c) => c.status == ConditionStatus.active)
            .toList();
      case HistoryFilter.resolved:
        return _conditions
            .where((c) => c.status == ConditionStatus.resolved)
            .toList();
      case HistoryFilter.chronic:
        return _conditions
            .where((c) => c.status == ConditionStatus.chronic)
            .toList();
    }
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final history =
          await _historyRepository.getPatientHistory(_patient.id);
      _profile = mapHistoryToProfile(history);
      _conditions = history.conditions.map(mapConditionToDemo).toList();
      _medications = history.medications.map(mapMedicationToDemo).toList();
      _allergies = [
        for (var i = 0; i < history.allergies.length; i++)
          mapAllergyToDemo(history.allergies[i], index: i + 1),
      ];
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _conditions = const [];
      _medications = const [];
      _allergies = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(HistoryFilter value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }
}
