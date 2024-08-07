1.0.0
=====

* Initial release.

* Lists alcohol dealers, their opening status and opening hours, and if location services are enabled, their distances in line-of-sight.

* Orders dealers by distance if distance is available, otherwise by descending opening hours.

1.1.0
=====

* Added support for unlocated stores in remote content (which broke earlier versions).

* Closed stores ordered below open stores.

**Note: Unlocated stores are hidden by default because they are not useful in the context of the user needing an immediate solution to alcohol shortage.**

1.1.1
=====

* Tolerance for unexpected description of month increased to fix crash bug.

1.1.2
=====

* Tolerance for messy GPS data increased to fix crash bug.

1.1.3
=====
*No functional changes.*

* Fastlane-compliant metadata directory structure added.

* Debug-banner removed when running in debug mode.

1.1.4
=====

* Null-safety implemented.

* Dependencies updated.

1.1.5
=====

* Flutter's geolocator replaced with [Flutter Geolocator FLOSS](https://gitlab.com/free2pass/flutter-geolocator-floss), for compliance with F-Droid.


* Build process: Sha256-checksum added for Gradle download at the suggestion of F-Droid.

1.1.6
=====
*No functional changes.*

* Markdown removed from full description in metadata for compatibility reasons.

1.2.0
=====

* Tolerance increased for faulty data.

* Ability to change languages via settings.

1.2.1
=====
*No functional changes.*

* Dependencies and code upgraded.

* Order of entries in changelog (this file) reversed to descending by time.
