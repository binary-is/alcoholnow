import 'constants.dart' as Constants;
import 'dealer/dealerpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';

void main() => runApp(AlcoholNowApp());

class AlcoholNowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: I18n(
        initialLocale: Locale('is', 'IS'),
        child: DealerPage(),
      ),

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('is', 'IS'),
      ],
    );
  }
}

