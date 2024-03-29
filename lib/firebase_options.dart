// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAimekaXz2OCn83BLi4HjSvJD0X8I6u-G4',
    appId: '1:482552608833:web:8d283419c923484a9e6ec0',
    messagingSenderId: '482552608833',
    projectId: 'mydict-194ff',
    authDomain: 'mydict-194ff.firebaseapp.com',
    storageBucket: 'mydict-194ff.appspot.com',
    measurementId: 'G-2MWQHWFSEV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxicKjJjw-5-LzeobOm6M1tQA_Sjr2y7k',
    appId: '1:482552608833:android:2b526e2be84b31419e6ec0',
    messagingSenderId: '482552608833',
    projectId: 'mydict-194ff',
    storageBucket: 'mydict-194ff.appspot.com',
  );
}
