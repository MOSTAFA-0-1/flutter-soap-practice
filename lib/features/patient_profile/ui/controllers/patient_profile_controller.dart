import 'package:flutter/foundation.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/patient_history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/mappers/history_ui_mapper.dart';

class PatientProfileController extends ChangeNotifier {
  PatientProfileController({
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
  bool _isLoading = true;
  String? _error;

  PatientProfileDemo get profile => _profile;
  PatientSearchItem get patient => _patient;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() => refresh();

  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final history =
          await _historyRepository.getPatientHistory(_patient.id);
      _profile = mapHistoryToProfile(history);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _profile = mapSearchItemToProfile(_patient);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
