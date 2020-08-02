import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;
import '../timing.dart';

class Dealer {
  final String name;
  final String image_url;
  final OpeningHours today;

  Dealer({this.name, this.image_url, this.today});

  factory Dealer.fromJson(Map<String, dynamic> json) {

    return Dealer(
      name: json['Name'],
      image_url: Constants.STORE_WEBSITE_URL + json['ImageUrl'],
      today: OpeningHours.fromPrimitive(json['today']['open']),
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

