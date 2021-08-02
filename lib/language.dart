import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Language {
  final String name;
  final Locale locale;
  Language({required this.name, required this.locale});
}

final languages = <Language>[
  Language(name: 'Íslenska', locale: Locale('is', 'IS')),
  Language(name: 'English', locale: Locale('en', 'US')),
];

// There must be a better way to do this, but we couldn't find it.
Locale? getLocaleByLanguageTag(String languageTag) {
  for (Language language in languages) {
    if (language.locale.toLanguageTag() == languageTag) {
      return language.locale;
    }
  }
  return null;
}

// There must be a better way to do this, but we couldn't find it.
int getLanguageTagOrder(String languageTag) {
  for (int i = 0; i < languages.length; i++) {
    if (languages[i].locale.toLanguageTag() == languageTag) {
      return i;
    }
  }
  return -1;
}
