import 'dart:async';
import 'package:intl/intl.dart';
import 'dealerpage.i18n.dart';
import 'dealer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart' as Constants;
import '../timing.dart';

// Returns a friendly human-readable representation of a number as a distance.
// TODO: Move to a utilities package.
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

class DealerPage extends StatefulWidget {
  @override
  _DealerPageState createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerPage> {
  List<Dealer> _dealers = [];
  Position _devicePosition;
  StreamController<List<Dealer>> controller = StreamController<List<Dealer>>();
  // TODO: Check if this needs releasing in an overridden dispose-method.
  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();

    fetchDealers().then((dealers) {
      _dealers = dealers;
      orderProperly(_dealers);
      controller.add(_dealers);
    }).catchError((e) {
      final String errorClass = e.runtimeType.toString();
      if (errorClass == 'SocketException') {
        controller.addError('The internet broke or something.'.i18n);
      }
      else if (errorClass == 'HttpException') {
        controller.addError('Remote server is drunk.'.i18n);
      }
      else {
        controller.addError(e.toString());
      }
    });

    startGeolocator();
  }

  void startGeolocator() {

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );
    positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) async {
      if (position != null) {

        // Find and remember the device's location.
        _devicePosition = Position(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        // Iterate through the dealers and update their distances.
        for (var dealer in _dealers) {
          dealer.distance = (await Geolocator().distanceBetween(
            position.latitude,
            position.longitude,
            dealer.position.latitude,
            dealer.position.longitude,
          )).round();
        }

        // Proper order is by distance, if available.
        orderProperly(_dealers);

        // Notify the UI.
        controller.add(_dealers);
      }
    });
  }

  void orderProperly(dealers) {
    dealers.sort((Dealer a, Dealer b) {
      int result;

      // First try to order by distance.
      result = a.distance - b.distance;

      // If distance is equal between stores (which only happens when
      // geolocation is unavailable), order by opening hours instead.
      if (result == 0) {
        result = a.next_opening.opens.compareTo(b.next_opening.opens);
      }

      return result;
    });
  }

  ListTile buildDealer(dealer) {

    /// We'll be using this again and again.
    final now = getNow();

    // Configure the dealer's description for opening hours.
    TextSpan sign;
    String description = '';
    if (dealer.isOpen()) {

      sign = TextSpan(
        text: 'Open!'.i18n,
        style: TextStyle(color: Colors.green),
      );

      description = 'Closes at %s.'.i18n.fill([hourDisplay(dealer.today.closes)]);

    }
    else {
      // Configure the text explaining that the dealer is closed and indicate
      // when it opens again if such information is available.

      if (dealer.today != null && dealer.today.opens.isAfter(now)) {
        sign = TextSpan(
          text: 'Opens later today!'.i18n,
          style: TextStyle(color: Colors.green),
        );
        description += 'Opens at %s and closes at %s.'.i18n.fill([
          hourDisplay(dealer.today.opens),
          hourDisplay(dealer.today.closes)
        ]);
      }
      else {
        sign = TextSpan(
          text: 'Closed!'.i18n,
          style: TextStyle(color: Colors.red),
        );
        if (dealer.today == null) {
          description = 'Closed all day.'.i18n;
        }
        else {
          description = 'Closed at %s.'.i18n.fill([hourDisplay(dealer.today.closes)]);
        }

        if (dealer.next_opening != null) {
          description += ' ' + 'Opens on %s at %s.'.i18n.fill([
            dateDisplay(dealer.next_opening.opens),
            hourDisplay(dealer.next_opening.opens),
          ]);
        }
      }

    }

    // If we've received location data so far, we'll add the distance.
    if (_devicePosition != null) {
      description += '\n' + '%s away.'.i18n.fill([distanceDisplay(dealer.distance)]);
    }

    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dealer.image_url),
      ),
      title: Text.rich(
        TextSpan(
          text: dealer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(text: ' - '),
            sign,
          ],
        ),
      ),
      subtitle: Text(description),
    );
  }

  @override
  Widget build(BuildContext context) {
    var body;

    body = StreamBuilder<List<Dealer>>(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          final List<ListTile> tiles = [];
          for (var dealer in snapshot.data) {
            if (dealer.isOpen() || !Constants.HIDE_CLOSED) {
              tiles.add(buildDealer(dealer));
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Controls.
              Expanded(
                child: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: tiles,
                  ).toList(),
                ),
              ),
            ],
          );

        }
        else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                 'Error:'.i18n,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
          );
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
