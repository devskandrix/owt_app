// File generated manually from android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist (equivalent to what `flutterfire
// configure` would generate for these two platforms).
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. This app '
        'only registers Android and iOS Firebase apps.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC73BNKoQZ-_pnWKysFEEXoCBMkm9GgT6w',
    appId: '1:623438415809:android:d139aeab89c3554696d140',
    messagingSenderId: '623438415809',
    projectId: 'owt-dating',
    storageBucket: 'owt-dating.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOgKvg39D0lVdLVBoukPB6n4WsImzeER0',
    appId: '1:623438415809:ios:76ea470750694aae96d140',
    messagingSenderId: '623438415809',
    projectId: 'owt-dating',
    storageBucket: 'owt-dating.firebasestorage.app',
    iosBundleId: 'com.example.owt',
    iosClientId: '623438415809-qohmq0fj1oaf53gvdq3gvo32g16e897k.apps.googleusercontent.com',
  );
}
