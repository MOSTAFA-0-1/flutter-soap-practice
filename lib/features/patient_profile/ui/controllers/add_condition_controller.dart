import 'package:flutter/foundation.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/condition.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/mappers/history_ui_mapper.dart';

class AddConditionController extends ChangeNotifier {
  AddConditionController({
    required PatientSearchItem patient,
    required HistoryRepository historyRepository,
  })  : _patient = patient,
        _historyRepository = historyRepository,
        _profile = mapSearchItemToProfile(patient);

  final PatientSearchItem _patient;
  final HistoryRepository _historyRepository;
  final PatientProfileDemo _profile;

  DateTime? _diagnosedDate;
  ConditionStatus? _status;
  bool _isSubmitting = false;
  String? _error;

  PatientSearchItem get patient => _patient;
  PatientProfileDemo get profile => _profile;
  DateTime? get diagnosedDate => _diagnosedDate;
  ConditionStatus? get status => _status;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  void setDiagnosedDate(DateTime date) {
    _diagnosedDate = date;
    notifyListeners();
  }

  void setStatus(ConditionStatus? status) {
    _status = status;
    notifyListeners();
  }

  Future<bool> submit({
    required String name,
    required String notes,
  }) async {
    if (_isSubmitting || _diagnosedDate == null || _status == null) {
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final condition = Condition(
        conditionId: 'C-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        diagnosedDate: _diagnosedDate!,
        status: conditionStatusToApi(_status!),
        notes: notes.isEmpty ? null : notes,
      );
      final ok = await _historyRepository.addCondition(_patient.id, condition);
      return ok;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
