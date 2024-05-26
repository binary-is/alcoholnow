import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byText('en_us') +
      {
        'en_us': 'Settings',
        'is_is': 'Stillingar',
      } +
      {
        'en_us': 'Language',
        'is_is': 'Tungumál',
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
