# Local copy of zego_uikit_prebuilt_call 4.24.6

Unmodified copy of `zego_uikit_prebuilt_call` 4.24.6 from pub.dev (minus
`example/`), with one change in
`lib/src/invitation/notification/notification_ring.dart`: the iOS speaker
ringtone no longer sets `AVAudioSessionOptions.mixWithOthers` on the
`ambient` category.

`audioplayers_platform_interface` 7.x asserts that `mixWithOthers` is only
used with `playback`, `playAndRecord` or `multiRoute`, so in debug builds
the ringtone threw when a call started ringing. `ambient` always mixes
with other audio anyway, so the ringtone behaves the same.

Used via `dependency_overrides` in the app's `pubspec.yaml`. Remove the
override (and this folder) once ZEGOCLOUD ships a fixed version.
