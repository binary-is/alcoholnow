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
