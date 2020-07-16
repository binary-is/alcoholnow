import 'constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'main.i18n.dart';

Future<String> fetchDealers() async {
  return Future.delayed(Duration(seconds: 3)).then((thing) => 'Some String');
}

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
  Future<String> _dealers;

  @override
  void initState() {
    super.initState();
    _dealers = fetchDealers();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    _entries = ['One'.i18n, 'Two'.i18n, 'Three'.i18n];

    body = FutureBuilder<String>(
      future: _dealers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
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
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Center(
          child: Text(
            'Loading...'.i18n,
            style: Theme.of(context).textTheme.headline
          )
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Now'.i18n),
      ),
      body: body
    );
  }
}
