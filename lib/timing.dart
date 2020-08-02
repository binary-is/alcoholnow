import 'package:intl/intl.dart';

// Abstraction for date and time management, especially for cases where we
// want to do some monkey business with time for development or testing
// purposes.

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

DateTime getNow() {
  DateTime now = DateTime.now();
  //now = now.add(Duration(hours: -2));
  return now;
}

DateTime dayAfter(dt) {
  return dt.add(new Duration(days: 1));
}

String clock(dt) {
    return DateFormat('HH:mm').format(dt);
}

