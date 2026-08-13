import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soap_practice/features/home/data/repositories/patient_repository.dart';
import 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';

export 'package:flutter_soap_practice/features/home/ui/models/patient_search_item.dart';

class PatientSearchController extends ChangeNotifier {
  PatientSearchController({required PatientRepository repository})
      : _repository = repository;

  static const _debounceDuration = Duration(milliseconds: 500);

  final PatientRepository _repository;

  String _query = '';
  List<PatientSearchItem> _filteredPatients = const [];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;
  int _searchGeneration = 0;

  String get query => _query;
  List<PatientSearchItem> get filteredPatients => _filteredPatients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateQuery(String value) {
    _query = value;
    notifyListeners();

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, search);
  }

  Future<void> search() async {
    _debounce?.cancel();

    final generation = ++_searchGeneration;
    final searchTerm = _query.trim();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final patients = await _repository.searchPatients(searchTerm);
      if (generation != _searchGeneration) return;

      _filteredPatients = List<PatientSearchItem>.unmodifiable(
        patients.map(PatientSearchItem.fromPatient),
      );
    } catch (e) {
      if (generation != _searchGeneration) return;
      _error = e.toString().replaceFirst('Exception: ', '');
      _filteredPatients = const [];
    } finally {
      if (generation == _searchGeneration) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
