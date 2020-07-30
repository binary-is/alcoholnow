import 'dart:async';
import 'package:flutter/material.dart';
import 'dealer.dart';
import 'dealerpage.i18n.dart';
import 'timing.dart';

class DealerPage extends StatefulWidget {
  @override
  _DealerPageState createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerPage> {
  List<Dealer> _dealers = [];
  StreamController<List<Dealer>> controller = StreamController<List<Dealer>>();

  @override
  void initState() {
    super.initState();

    fetchDealers().then((dealers) {
      _dealers = dealers;
      controller.add(_dealers);
    });
  }

  ListTile buildDealer(dealer) {

    /// We'll be using this again and again.
    final now = getNow();

    // Configure the text that explains things when the dealer is open.
    final String open_text = 'Open. Closes at '.i18n + clock(dealer.today.closes) + '.';

    // Configure the text explaining that the dealer is closed and indicate
    // when it opens again if such information is available.
    String closed_text = 'Closed.'.i18n;
    if (dealer.today != null) {
      // If dealer.today is not null, then the store either was, or is open today.
      if (dealer.today.opens.isAfter(now)) {
        closed_text += ' Opens at '.i18n + clock(dealer.today.opens);
        closed_text += ' and closes at '.i18n + clock(dealer.today.closes) + '.';
      }
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dealer.image_url),
      ),
      title: Text(dealer.name),
      subtitle: Text(dealer.isOpen() ? open_text : closed_text),
    );
  }

  @override
  Widget build(BuildContext context) {
    var body;

    body = StreamBuilder<List<Dealer>>(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Controls.
              Expanded(
                child: ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      for (var dealer in snapshot.data) buildDealer(dealer),
                    ],
                  ).toList(),
                ),
              ),
            ],
          );

        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
