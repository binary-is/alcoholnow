# Er ríkið opið? (AlcoholNow)

„Er ríkið opið?“ is a panic button for Android (and possibly iOS *developers*) who must immediately know the opening hours of alcohol stores in Iceland and their line-of-sight distance.

## Features
- An immediate list of alcohol stores in Iceland, their opening hours and whether they are currently open.
- Alcohol dealers are ordered by distance (when location services are available and enabled).

## Installing and building

### Downloadable packages
If you just want to install it on your Android phone, you can download the most recent version of the appropriate `apk` package on the [GitHub release page](https://github.com/binary-is/alcoholnow/releases) or from F-Droid [here](https://f-droid.org/packages/is.binary.alcoholnow/). Packages are provided for each architecture, but if you don't know your Android device's architecture, you can use the one called `alcoholnow-<version>.apk`. It works for all Android architectures but is about three times as big as the architecture-specific packages.

**Note**: Your phone will warn you about the package not being from a known, trusted source. Proceed only if you trust this repository. If you're feeling paranoid, you can build your own package.

Unfortunately, there are no packages available for iOS. You might be able to install the app to your iOS device by building it yourself.

### Building
For building, just [set up flutter](https://flutter.dev/docs/get-started/install) and run it with `flutter run` with an emulator or device attached. Follow the Flutter instructions for building packages if you're into that.

## Disclaimers
1. This project was only developed as an exercise in Android app development using Flutter. There is no serious effort behind it and no commitment to maintain it or even fix bugs, except to keep the app working on the mobile phone of the author and perhaps the author's wife.

2. It is currently **not** distributed in Google's *Play Store* or Apple's *App Store* because frankly, it's beyond the purpose of the project. Downloadable Android packages are provided, and the code seems to work just fine on an iOS emulator, but that's the extent of iOS support. This may change in the future but is not on any roadmap. If you're interested in distributing the project in either store, or even if you're just of the opinion that it belongs there, feel free to contact the author.

## License
Distributed under the terms of the open-source MIT license. See the file `LICENSE` for details.

## Authors
- Helgi Hrafn Gunnarsson <helgi@binary.is>

Special thanks to Iceland's state-run alcohol monopoly for providing JSON data, generally excellent service and alcohol.
