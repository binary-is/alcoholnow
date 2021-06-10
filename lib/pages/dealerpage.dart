import 'dealerpage.i18n.dart';
import 'package:flutter/material.dart';
import '../widgets/dealerlist.dart';

class DealerPage extends StatefulWidget {
  @override
  _DealerPageState createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Now'.i18n),
        /* Commented until complete.
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.of(context).pushNamed('/settings'),
        ),
        */
      ),
      body: DealerList(),
    );
  }
}
