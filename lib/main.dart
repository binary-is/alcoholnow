import 'dart:async';

import 'constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'main.i18n.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Dealer {
  final String name;
  final String image_url;
  final bool is_open;
  final DateTime opens;
  final DateTime closes;

  Dealer({this.name, this.image_url, this.is_open, this.opens, this.closes});

  factory Dealer.fromJson(Map<String, dynamic> json) {

    // Default state of opens/closes if no info is to be had. If this is left
    // untouched, then the dealer is not open at any time today.
    DateTime opens = null;
    DateTime closes = null;

    // For example, the string "11 - 18" means that a dealer opens at 11:00 AM
    // and closes at 6:00 PM.
    final primitive_hours = json['today']['open'].split(' - ');

    // If the above-mentioned format results in exactly two values, we know
    // that opening hours apply (i.e. the store is open at some point today).
    if (primitive_hours.length == 2) {
      final now = DateTime.now();
      opens = DateTime(now.year, now.month, now.day, int.parse(primitive_hours[0]));
      closes = DateTime(now.year, now.month, now.day, int.parse(primitive_hours[1]));
    }

    return Dealer(
      name: json['Name'],
      image_url: '${Constants.STORE_WEBSITE_URL}${json['ImageUrl']}',
      is_open: json['isOpenNow'],
      opens: opens,
      closes: closes,
    );
  }

  @override
  String toString() {
    return 'Dealer object named "${this.name}"';
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
  List<Dealer> _dealers = [];
  StreamController<List<Dealer>> controller = StreamController<List<Dealer>>();

  @override
  void initState() {
    super.initState();

    fetchDealers().then((dealers) {
      _dealers = dealers;
      controller.add(_dealers);
    });
  }

  ListTile buildDealer(dealer) {

    final open_text = 'Open'.i18n + '. ' + 'Closes at'.i18n + ' ' + DateFormat('HH:mm').format(dealer.closes) + '.';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dealer.image_url),
      ),
      title: Text(dealer.name),
      subtitle: Text(dealer.is_open ? open_text : 'Closed'.i18n + '.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    var body;

    body = StreamBuilder<List<Dealer>>(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Controls.
              Expanded(
                child: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      for (var dealer in snapshot.data) buildDealer(dealer),
                    ],
                  ).toList(),
                ),
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
