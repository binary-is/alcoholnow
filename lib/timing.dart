import 'package:intl/intl.dart';

// Abstraction for date and time management, especially for cases where we
// want to do some monkey business with time for development or testing
// purposes.

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

