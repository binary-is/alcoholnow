import 'constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'main.i18n.dart';

void main() => runApp(AlcoholNowApp());

class AlcoholNowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: I18n(
        initialLocale: Locale('is', 'IS'),
        child: MainPage(),
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> _entries;
  bool _isLoading = true;

  void fetchDealers() async {
    // Fake time-consumption to make sure loading message works.
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDealers();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    _entries = ['One'.i18n, 'Two'.i18n, 'Three'.i18n];

    if (_isLoading) {
      body = Center(
        child: Text(
          'Loading...'.i18n,
          style: Theme.of(context).textTheme.headline
        )
      );
    }
    else {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hello, world".i18n,
            style: Theme.of(context).textTheme.subhead
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_entries[index])
                );
              },
            )
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Now'.i18n),
      ),
      body: body
    );
  }
}
