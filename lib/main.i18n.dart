import 'package:i18n_extension/i18n_extension.dart';
import 'constants.dart' as Constants;

extension Localization on String {
  static var _t = Translations('en_us') + {
    'en_us': 'Alcohol Now',
    'is_is': Constants.APP_NAME,
  };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
