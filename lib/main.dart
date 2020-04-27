import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale/app_localization.dart';

void main() => runApp(AlcoholNowApp());

class AlcoholNowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AppLocalizationDelegate _localeOverrideDelegate = AppLocalizationDelegate(Locale('is', 'IS'));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        _localeOverrideDelegate
      ],
      supportedLocales: [
        const Locale('is', 'IS'),
        const Locale('en', 'US'),
      ],
      home: MainPage(title: 'Alcohol Now'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> _entries = ['One', 'Two', 'Three'];
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
    AppLocalization.load(Locale('is', 'IS'));
    fetchDealers();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    if (_isLoading) {
      body = Center(
        child: Text(
          'Loading...',
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
            AppLocalization.of(context).heyWorld,
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
        title: Text(widget.title),
      ),
      body: body
    );
  }
}
