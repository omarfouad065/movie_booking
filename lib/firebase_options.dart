// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6-UybFQ6Qp8CrB8Y8KH3AL8bMSuSMI1Y',
    appId: '1:58175005013:web:4de8fbf367a8a8b3f14fdc',
    messagingSenderId: '58175005013',
    projectId: 'filmyfun-70562',
    authDomain: 'filmyfun-70562.firebaseapp.com',
    storageBucket: 'filmyfun-70562.firebasestorage.app',
    measurementId: 'G-BYPY8WNM3W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJgq174tF8SR1NErPcOPZgNdduimv7WdQ',
    appId: '1:58175005013:android:435150c11192077cf14fdc',
    messagingSenderId: '58175005013',
    projectId: 'filmyfun-70562',
    storageBucket: 'filmyfun-70562.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAShCd8ZEgLLITV-XFt763dDpQ4bwqwAHo',
    appId: '1:58175005013:ios:1c8bf51c052279f6f14fdc',
    messagingSenderId: '58175005013',
    projectId: 'filmyfun-70562',
    storageBucket: 'filmyfun-70562.firebasestorage.app',
    iosBundleId: 'com.example.movieBooking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAShCd8ZEgLLITV-XFt763dDpQ4bwqwAHo',
    appId: '1:58175005013:ios:1c8bf51c052279f6f14fdc',
    messagingSenderId: '58175005013',
    projectId: 'filmyfun-70562',
    storageBucket: 'filmyfun-70562.firebasestorage.app',
    iosBundleId: 'com.example.movieBooking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6-UybFQ6Qp8CrB8Y8KH3AL8bMSuSMI1Y',
    appId: '1:58175005013:web:674982c85977eb74f14fdc',
    messagingSenderId: '58175005013',
    projectId: 'filmyfun-70562',
    authDomain: 'filmyfun-70562.firebaseapp.com',
    storageBucket: 'filmyfun-70562.firebasestorage.app',
    measurementId: 'G-4VDSSFYK1F',
  );
}
