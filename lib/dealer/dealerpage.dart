import 'dart:async';
import 'dealerpage.i18n.dart';
import 'dealer.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart' as Constants;
import '../display_utils.dart';
import '../timing_utils.dart';

class DealerPage extends StatefulWidget {
  @override
  _DealerPageState createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerPage> {
  // A list of all our dealers. This list gets updated when new data arrives,
  // such as a new device location, and then the UI is updated by adding this
  // list again to the _dealerController.
  List<Dealer> _dealers = [];

  // Last known device position. If still null, then no position data has arrived yet.
  Position _devicePosition;

  // A stream controller for the dealers. When dealer data (in _dealer) is
  // updated, the UI is updated by calling _dealerController.add(_dealers).
  StreamController<List<Dealer>> _dealerController = StreamController<List<Dealer>>();

  // A stream subscription for new device positions. It is not really needed,
  // but we cancel the subscription on the disposal of the page for the sake
  // of formality. It shouldn't be strictly necessary because the stream is
  // used for as long as the app remains open.
  StreamSubscription<Position> _positionSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize geolocation stuff.
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );

    // Fetch dealers from remote source.
    fetchDealers().then((dealers) async {
      // We'll need to access dealers again later.
      _dealers = dealers;

      // Check if we already have location data to order by.
      if (
        await geolocator.isLocationServiceEnabled()
        && await geolocator.checkGeolocationPermissionStatus() == GeolocationStatus.granted
      ) {
        Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (position != null) {
          await updateDealerPositions(position);
        }
      }

      // Order dealers according to available parameters.
      orderProperly(_dealers);

      // Notify the UI about new dealer data.
      _dealerController.add(_dealers);

      // Start listening for new location updates.
      _positionSubscription = geolocator.getPositionStream(locationOptions).listen(updateDealerPositions);

    }).catchError((e, s) {
      final String errorClass = e.runtimeType.toString();
      if (errorClass == 'SocketException') {
        _dealerController.addError('The internet broke or something.'.i18n);
      }
      else if (errorClass == 'HttpException') {
        _dealerController.addError('Remote server is drunk.'.i18n);
      }
      else {
        _dealerController.addError(e.toString());
        if (!Foundation.kReleaseMode) {
          print(s.toString());
        }
      }
    });
  }

  @override
  void dispose() {
    // Not really needed, because the stream is used for as long as the app
    // lives, but we still do this for the sake of formality.
    _positionSubscription.cancel();

    super.dispose();
  }

  void updateDealerPositions(Position position) async {
    if (position != null) {

      // Find and remember the device's location.
      _devicePosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Iterate through the dealers and update their distances.
      for (var dealer in _dealers) {
        if (dealer.position != null) {
          dealer.distance = (await Geolocator().distanceBetween(
            position.latitude,
            position.longitude,
            dealer.position.latitude,
            dealer.position.longitude,
          )).round();
        }
      }

      // Proper order is by distance, if available.
      orderProperly(_dealers);

      // Notify the UI.
      _dealerController.add(_dealers);
    }
  }

  void orderProperly(dealers) {
    dealers.sort((Dealer a, Dealer b) {
      int result = 0;

      // First: Order by open/closed status.
      if (a.isOpen() && !b.isOpen()) {
        result = -1;
      }
      else if (!a.isOpen() && b.isOpen()) {
        result = 1;
      }

      // Second: Order by distance.
      if (result == 0) {
        result = a.distance - b.distance;
      }

      // Third: If distance is equal between stores (typically when
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
      stream: _dealerController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          final List<ListTile> tiles = [];
          for (var dealer in snapshot.data) {

            // Respect config: HIDE_CLOSED.
            if (Constants.HIDE_CLOSED && !dealer.isOpen()) {
              continue;
            }

            // Respect config: HIDE_UNLOCATED.
            if (Constants.HIDE_UNLOCATED && dealer.position == null) {
              continue;
            }

            // Add the dealer to the visible list.
            tiles.add(buildDealer(dealer));
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
