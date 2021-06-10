/* Utility-functions for managing time in a consistent manner. Also allows for
 * developers to monkey around with time for development purposes.
 */

DateTime getNow() {
  DateTime now = DateTime.now();
  //now = now.add(Duration(hours: -2));
  return now;
}
