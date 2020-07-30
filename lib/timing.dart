// Abstraction for date and time management, especially for cases where we
// want to do some monkey business with time for development or testing
// purposes.

class OpeningHours {
  final DateTime opens;
  final DateTime closes;

  OpeningHours({this.opens, this.closes});

  // Note: This function assumes that the primitive string (f.e. "11 - 18")
  // refers to today. If another date is needed, the returned value must be
  // manipulated afterwards. Note the "dayAfter" function in this file.
  factory OpeningHours.fromPrimitive(primitive_string) {

    // For example, the string "11 - 18" means that a dealer opens at 11:00 AM
    // and closes at 6:00 PM.
    final primitive_hours = primitive_string.split(' - ');

    // If the above-mentioned format results in exactly two values, we know
    // that opening hours apply (i.e. the store is open at some point today).
    if (primitive_hours.length == 2) {
      final now = getNow();
      return OpeningHours(
        opens: DateTime(now.year, now.month, now.day, int.parse(primitive_hours[0])),
        closes: DateTime(now.year, now.month, now.day, int.parse(primitive_hours[1])),
      );
    }
    else {
      // Null means that the dealer is not open at any time during the day.
      return null;
    }
  }
}

DateTime getNow() {
  return DateTime.now();
}

DateTime dayAfter(dt) {
  return dt.add(new Duration(days: 1));
}

