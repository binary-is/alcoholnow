import 'package:flutter/material.dart';
import 'settingspage.i18n.dart';

class SettingsPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Settings'.i18n),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Language'.i18n),
              onTap: () {
                Navigator.of(context).pushNamed('/settings/language');
              },
            ),
          ],
        ),
      );
    }
}
