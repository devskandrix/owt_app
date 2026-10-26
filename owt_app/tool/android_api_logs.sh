#!/bin/sh
# Streams the debug build's full API logs from an Android phone, unmasked.
# Some phones (e.g. Vivo) hide URLs and coordinates in logcat, so the
# `flutter run` console shows ***** — this reads the app's own copy
# (see lib/core/network/debug_log/) straight from its storage instead.
#
# Usage: tool/android_api_logs.sh [device-id]   (from `flutter devices`)
ADB="${ADB:-adb}"
command -v "$ADB" >/dev/null 2>&1 || ADB="$HOME/Library/Android/sdk/platform-tools/adb"
if [ -n "$1" ]; then
  exec "$ADB" -s "$1" exec-out run-as com.example.owt tail -n +1 -f code_cache/api_log.txt
fi
exec "$ADB" exec-out run-as com.example.owt tail -n +1 -f code_cache/api_log.txt
