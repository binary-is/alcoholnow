import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en_us') + {
    'en_us': 'Alcohol Now',
    'is_is': 'Er ríkið opið?',
  };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
