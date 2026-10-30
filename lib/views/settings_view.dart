import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final lang = settings.language;

    final isEn = lang == 'en';
    final isFr = lang == 'fr';

    final titleText = isEn
        ? 'Preferences'
        : (isFr ? 'Paramètres' : 'Preferencias');
    final darkThemeText = isEn
        ? 'Dark Theme'
        : (isFr ? 'Thème sombre' : 'Tema Oscuro');
    final langSelectText = isEn
        ? 'Select Language'
        : (isFr ? 'Sélectionner la langue' : 'Seleccionar Idioma');
    final saveButtonText = isEn
        ? 'Save Preferences'
        : (isFr ? 'Enregistrer' : 'Guardar Preferencias');
    final snackbarText = isEn
        ? 'Settings saved successfully'
        : (isFr
              ? 'Paramètres enregistrés avec succès'
              : 'Preferencias guardadas exitosamente');

    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text(darkThemeText),
            value: settings.isDarkTheme,
            onChanged: (val) => settings.setTheme(val),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              langSelectText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<String>(
            value: settings.language,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'es', child: Text('Español')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fr', child: Text('Français')),
            ],
            onChanged: (val) {
              if (val != null) settings.setLanguage(val);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await settings.saveSettings();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(snackbarText)));
              }
            },
            child: Text(saveButtonText),
          ),
        ],
      ),
    );
  }
}
