# Local copy of zego_zim 3.2.0

Unmodified copy of `zego_zim` 3.2.0 from pub.dev (minus `example/`), with
one change: the two `jcenter()` lines are removed from
`android/build.gradle`. `jcenter()` no longer exists in Gradle 9, so the
pub.dev version fails to build with this project's Gradle 9.3 / AGP 9.1.

Used via `dependency_overrides` in the app's `pubspec.yaml`. Remove the
override (and this folder) once ZEGOCLOUD ships a `zego_zim` without
`jcenter()`.
