import 'constants.dart' as Constants;
import 'dealer/dealerpage.dart';
import 'main.i18n.dart';
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
        child: StatefulScaffold(),
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

// The translation mechanism only works on stateful widgets, so we make this
// stateful version of the Scaffold widget only to contain things we'll want
// to translate.
class StatefulScaffold extends StatefulWidget {
  @override
  _StatefulScaffoldState createState() => _StatefulScaffoldState();
}

class _StatefulScaffoldState extends State<StatefulScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Now'.i18n),
      ),
      body: DealerPage(),
    );
  }
}
