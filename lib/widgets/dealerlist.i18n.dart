import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byText('en-US') +
      {
        'en-US': 'Loading...',
        'is-IS': 'Hleð...',
      } +
      {
        'en-US': 'Open!',
        'is-IS': 'Opið!',
      } +
      {
        'en-US': 'Opens later today!',
        'is-IS': 'Opnar seinna í dag!',
      } +
      {
        'en-US': 'Opens on %s at %s.',
        'is-IS': 'Opnar %s kl. %s.',
      } +
      {
        'en-US': 'Closed!',
        'is-IS': 'Lokað!',
      } +
      {
        'en-US': 'Opens at %s and closes at %s.',
        'is-IS': 'Opnar kl. %s og lokar kl. %s.',
      } +
      {
        'en-US': 'Closes at %s.',
        'is-IS': 'Lokar kl. %s.',
      } +
      {
        'en-US': 'Closed at %s.',
        'is-IS': 'Lokaði kl. %s.',
      } +
      {
        'en-US': 'Closed all day.',
        'is-IS': 'Lokað í allan dag.',
      } +
      {
        'en-US': '%s away.',
        'is-IS': 'Í %s fjarlægð.',
      } +
      {
        'en-US': '%s meters',
        'is-IS': '%s metra',
      } +
      {
        'en-US': '%s kilometers',
        'is-IS': '%s kílómetra',
      } +
      {
        'en-US': 'Error:',
        'is-IS': 'Villa:',
      } +
      {
        'en-US': 'Remote server is drunk.',
        'is-IS': 'Netþjónninn er ölvaður.',
      } +
      {
        'en-US': 'The internet broke or something.',
        'is-IS': 'Internetið er eitthvað beyglað.',
      };

  String get i18n => localize(this, _t);
}
