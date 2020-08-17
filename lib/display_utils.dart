/*
 * Utilify functions for displaying various data in a consistent manner,
 * respecting things like locale and app-specific decisions on presentation.
 */

import 'constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'dealer/dealerpage.i18n.dart';

String hourDisplay(dt) {
    return DateFormat('HH:mm').format(dt);
}

String dateDisplay(dt) {
    // The formatting here is hard-coded to Icelandic for now, but this should
    // be changed once we make other languages/locales selectable by the user.
    return DateFormat.MMMMd(Constants.MAIN_LOCALE).format(dt);
}

// Returns a friendly human-readable representation of a number as a distance.
String distanceDisplay(distance) {
  String result;

  if (distance > 999) {
    double reducedDistance = (distance / 10).round() / 100;
    result = NumberFormat.compact(locale: Constants.MAIN_LOCALE).format(reducedDistance);
    return '%s kilometers'.i18n.fill([result]);
  }
  else {
    return '%s meters'.i18n.fill([distance]);
  }
}
