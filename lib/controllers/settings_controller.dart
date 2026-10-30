import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class SettingsController extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();

  bool _isDarkTheme = false;
  String _language = 'es';

  bool get isDarkTheme => _isDarkTheme;
  String get language => _language;

  Future<void> loadPreferences() async {
    _isDarkTheme = await _prefsService.getTheme();
    _language = await _prefsService.getLanguage();
    notifyListeners();
  }

  void setTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await _prefsService.savePreferences(
      isDarkTheme: _isDarkTheme,
      language: _language,
    );
  }
}
