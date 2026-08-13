import 'package:flutter/foundation.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/models/medication.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/data/repositories/patient_history_repository.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/controllers/patient_demo_types.dart';
import 'package:flutter_soap_practice/features/patient_profile/ui/mappers/history_ui_mapper.dart';

class ManageMedicationsController extends ChangeNotifier {
  ManageMedicationsController({
    required PatientSearchItem patient,
    required PatientHistoryRepository historyRepository,
    required HistoryRepository mutationRepository,
  })  : _patient = patient,
        _historyRepository = historyRepository,
        _mutationRepository = mutationRepository,
        _profile = mapSearchItemToProfile(patient) {
    load();
  }

  final PatientSearchItem _patient;
  final PatientHistoryRepository _historyRepository;
  final HistoryRepository _mutationRepository;

  PatientProfileDemo _profile;
  final List<MedicationDemo> _medications = [];

  String? _editingId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;
  int _nextId = 9000;

  PatientSearchItem get patient => _patient;
  PatientProfileDemo get profile => _profile;
  List<MedicationDemo> get medications => List.unmodifiable(_medications);
  String? get editingId => _editingId;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isEditing => _editingId != null;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final history =
          await _historyRepository.getPatientHistory(_patient.id);
      _profile = mapHistoryToProfile(history);
      _medications
        ..clear()
        ..addAll(history.medications.map(mapMedicationToDemo));
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _medications.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void clearEndDate() {
    _endDate = null;
    notifyListeners();
  }

  MedicationDemo? beginEdit(String id) {
    final match = _medications.where((m) => m.id == id);
    if (match.isEmpty) return null;
    final med = match.first;
    _editingId = med.id;
    _startDate = med.startDate;
    _endDate = med.endDate;
    notifyListeners();
    return med;
  }

  void clearFormDates({bool clearEditing = true}) {
    if (clearEditing) _editingId = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  void deleteMedication(String id) {
    _medications.removeWhere((m) => m.id == id);
    if (_editingId == id) {
      _editingId = null;
      _startDate = null;
      _endDate = null;
    }
    notifyListeners();
  }

  Future<bool> saveMedication({
    required String name,
    required String dosage,
    required String frequency,
    required String prescriber,
  }) async {
    if (_isSubmitting || _startDate == null) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final medicationId = _editingId ?? 'M-${_nextId++}';
    final medication = Medication(
      medicationId: medicationId,
      name: name,
      dosage: dosage,
      frequency: frequency,
      startDate: _startDate!,
      endDate: _endDate,
      prescribingDoctor: prescriber,
    );

    try {
      final ok = await _mutationRepository.updateMedication(
        _patient.id,
        medication,
      );
      if (!ok) return false;

      final demo = mapMedicationToDemo(medication);
      if (_editingId != null) {
        final index = _medications.indexWhere((m) => m.id == _editingId);
        if (index >= 0) {
          _medications[index] = demo;
        }
      } else {
        _medications.insert(0, demo);
      }

      _editingId = null;
      _startDate = null;
      _endDate = null;
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
