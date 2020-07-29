import 'Constants.dart' as Constants;
import 'dart:convert';
import 'package:http/http.dart' as http;

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

