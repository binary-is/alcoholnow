import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;
import '../timing.dart';

class OpeningHours {

  // We won't rely on conventions, but rather the actual known data. This is
  // simpler, more readable and possibly even more reliable than trying to
  // parse the input strings as Icelandic short-months with some library.
  static const IcelandicMonthMap = {
    'jan.': 1,
    'feb.': 2,
    'mar.': 3,
    'apr.': 4,
    'maí.': 5,
    'jún.': 6,
    'júl.': 7,
    'ágú.': 8,
    'sep.': 9,
    'okt.': 10,
    'nóv.': 11,
    'des.': 12,
  };

  final DateTime opens;
  final DateTime closes;

  OpeningHours({this.opens, this.closes});

  factory OpeningHours.fromPrimitive(json) {

    // Current year assumed. Calling function must remedy if this is wrong.
    final int year = getNow().year;
    final int month = IcelandicMonthMap[json['date'].substring(json['date'].indexOf('.') + 2)];
    final int day = int.parse(json['date'].substring(0, json['date'].indexOf('.')));

    // For example, the string "11 - 18" means that a dealer opens at 11:00 AM
    // and closes at 6:00 PM.
    final primitive_hours = json['open'].split(' - ');

    // If primitive_hours has exactly two values, we know that the store is
    // open at some point during the day.
    if (primitive_hours.length == 2) {
      return OpeningHours(
        opens: DateTime(year, month, day, int.parse(primitive_hours[0])),
        closes: DateTime(year, month, day, int.parse(primitive_hours[1])),
      );
    }
    else {
      // Null means that the dealer is not open at any time during the day.
      return null;
    }
  }
}

class Dealer {
  final String name;
  final String image_url;
  final OpeningHours today;

  Dealer({this.name, this.image_url, this.today});

  factory Dealer.fromJson(Map<String, dynamic> json) {

    return Dealer(
      name: json['Name'],
      image_url: Constants.STORE_WEBSITE_URL + json['ImageUrl'],
      today: OpeningHours.fromPrimitive(json['today']),
    );
  }

  bool isOpen() {
    final now = getNow();
    return today != null && now.isAfter(today.opens) && now.isBefore(today.closes);
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
    throw HttpException(
      'Unexpectectly received HTTP code ${response.statusCode} when expecting 200.',
    );
  }
}

