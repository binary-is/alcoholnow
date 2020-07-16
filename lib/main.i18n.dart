import 'constants.dart' as Constants;
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en_us') + {
    'en_us': 'Hello, world',
    'is_is': 'Halló, heimur',
  } + {
    'en_us': 'Alcohol Now',
    'is_is': Constants.APP_NAME,
  } + {
    'en_us': 'One',
    'is_is': 'Einn',
  } + {
    'en_us': 'Two',
    'is_is': 'Tveir',
  } + {
    'en_us': 'Three',
    'is_is': 'Þrír',
  } + {
    'en_us': 'Loading...',
    'is_is': 'Hleð...',
  };

  String get i18n => localize(this, _t);
}
