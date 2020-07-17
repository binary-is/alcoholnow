import 'constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'main.i18n.dart';
import 'dart:convert';

class Dealer {
  final String name;
  final String image_url;
  final bool is_open;

  Dealer({this.name, this.image_url, this.is_open});

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      name: json['Name'],
      image_url: '${Constants.STORE_WEBSITE_URL}${json['ImageUrl']}',
      is_open: json['isOpenNow'],
    );
  }
}

Future<List<Dealer>> fetchDealers() async {

  final response = await http.get(
    Constants.STORE_DATA_URL,
    headers: {
      'Content-Type': 'application/json; charset=utf-8'
    }
  );

  if (response.statusCode == 200) {
    /* The JSON we receive from the store URL is a bit weird. Instead of
     * returning JSON, it returns JSON with a single string called "d". This
     * string then contains string-encoded JSON. We don't know why.
     */
    final list = json.decode(json.decode(response.body)['d']) as List;

    final List<Dealer> dealers = list.map((item) => Dealer.fromJson(item)).toList();

    return dealers;
  }
  else {
    throw Exception('HTTP error ${response.statusCode} received while fetching stores.');
  }
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
  Future<List<Dealer>> _dealers;

  @override
  void initState() {
    super.initState();
    _dealers = fetchDealers();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    body = FutureBuilder<List<Dealer>>(
      future: _dealers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Controls.
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final dealer = snapshot.data[index];
                    return ListTile(
                      leading: Image.network(
                        dealer.image_url,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      title: Text(dealer.name),
                      subtitle: Text(dealer.is_open ? 'Open'.i18n : 'Closed'.i18n),
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
