import 'constants.dart' as Constants;
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

String hourDisplay(dt) {
    return DateFormat('HH:mm').format(dt);
}

String dateDisplay(dt) {
    // The formatting here is hard-coded to Icelandic for now, but this should
    // be changed once we make other languages/locales selectable by the user.
    return DateFormat.MMMMd(Constants.MAIN_LOCALE).format(dt);
}

