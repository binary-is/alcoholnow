import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'constants.dart' as Constants;
import 'pages/dealerpage.dart';
import 'pages/settingspage.dart';

void main() => runApp(AlcoholNowApp());

class AlcoholNowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return I18n(
      initialLocale: Locale('is', 'IS'),
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
          const Locale('en', 'US'),
          const Locale('is', 'IS'),
        ],

      ),
    );
  }
}
