import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'constants.dart' as Constants;
import 'language.dart';
import 'pages/dealerpage.dart';
import 'pages/settingspage.dart';

void main() async {
  await Settings.init();
  runApp(AlcoholNowApp());
}

class AlcoholNowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String languageTag = Settings.getValue('languageTag') ?? '';
    final Locale? locale =
        getLocaleByLanguageTag(languageTag) ?? Constants.DEFAULT_LOCALE;

    return I18n(
      initialLocale: locale,
      child: MaterialApp(
        // Development and miscellaneous.
        debugShowCheckedModeBanner: false,

        // Look and feel.
        title: Constants.APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        // Routes.
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => DealerPage(),
          '/settings': (BuildContext context) => SettingsPage(),
        },

        // Locale-related.
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          for (Language language in languages) language.locale,
        ],
      ),
    );
  }
}
