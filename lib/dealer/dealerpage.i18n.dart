import 'package:i18n_extension/i18n_extension.dart';
import '../constants.dart' as Constants;

extension Localization on String {
  static var _t = Translations('en_us') + {
    'en_us': 'Alcohol Now',
    'is_is': Constants.APP_NAME,
  } + {
    'en_us': 'Loading...',
    'is_is': 'Hleð...',
  } + {
    'en_us': 'Open!',
    'is_is': 'Opið!',
  } + {
    'en_us': 'Opens later today!',
    'is_is': 'Opnar seinna í dag!',
  } + {
    'en_us': 'Closed!',
    'is_is': 'Lokað!',
  } + {
    'en_us': 'Opens at ',
    'is_is': 'Opnar kl. ',
  } + {
    'en_us': ' and closes at ',
    'is_is': ' og lokar kl. ',
  } + {
    'en_us': 'Closes at ',
    'is_is': 'Lokar kl. ',
  } + {
    'en_us': 'Closed at ',
    'is_is': 'Lokaði kl. ',
  } + {
    'en_us': 'Closed all day.',
    'is_is': 'Lokað í allan dag.',
  } + {
    'en_us': 'Error:',
    'is_is': 'Villa:',
  } + {
    'en_us': 'Remote server is drunk.',
    'is_is': 'Netþjónninn er ölvaður.',
  } + {
    'en_us': 'The internet broke or something.',
    'is_is': 'Internetið er eitthvað beyglað.',
  };

  String get i18n => localize(this, _t);
}
