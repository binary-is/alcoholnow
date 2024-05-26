import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'settingspage.i18n.dart';
import '../constants.dart' as Constants;
import '../language.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String languageTag = Settings.getValue('languageTag') ??
        Constants.DEFAULT_LOCALE.toLanguageTag();

    int selectedValue = getLanguageTagOrder(languageTag) + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.i18n),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DropDownSettingsTile<int>(
            title: 'Language'.i18n,
            settingKey: 'language',
            values: <int, String>{
              for (int i = 0; i < languages.length; i++)
                i + 1: languages[i].name
            },
            //selected: selectedValue,
            selected: selectedValue,
            onChange: (value) {
              Language language = languages[value - 1];
              Settings.setValue('languageTag', language.locale.toLanguageTag());
              I18n.of(context).locale = language.locale;
            },
          ),
        ],
      ),
    );
  }
}
