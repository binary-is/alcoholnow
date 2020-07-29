import 'constants.dart' as Constants;
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations('en_us') + {
    'en_us': 'Alcohol Now',
    'is_is': Constants.APP_NAME,
  } + {
    'en_us': 'Loading...',
    'is_is': 'Hleð...',
  } + {
    'en_us': 'Open',
    'is_is': 'Opið',
  } + {
    'en_us': 'Closed',
    'is_is': 'Lokað',
  } + {
    'en_us': 'Closes at',
    'is_is': 'Lokar kl.',
  };

  String get i18n => localize(this, _t);
}
