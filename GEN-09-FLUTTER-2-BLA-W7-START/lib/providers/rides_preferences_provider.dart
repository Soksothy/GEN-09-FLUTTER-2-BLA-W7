import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/ride_preferences_repository.dart';
import '../model/ride/ride_pref.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences once during initialization
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference == pref) return;

    _currentPreference = pref;

    // Ensure history contains unique preferences
    _pastPreferences.removeWhere((p) => p == pref);
    _pastPreferences.insert(0, pref);

    notifyListeners();
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
