import 'dart:async';
import 'package:flutter/material.dart';
import 'dealer.dart';
import 'dealerpage.i18n.dart';
import 'package:intl/intl.dart';

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

    final open_text = 'Open'.i18n + '. ' + 'Closes at'.i18n + ' ' + DateFormat('HH:mm').format(dealer.today.closes) + '.';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dealer.image_url),
      ),
      title: Text(dealer.name),
      subtitle: Text(dealer.isOpen() ? open_text : 'Closed'.i18n + '.'),
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
