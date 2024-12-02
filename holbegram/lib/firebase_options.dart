import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? 'fallback_api_key',
    appId: '1:428601249657:web:bad3d3e0ae93c70e98e9a8',
    messagingSenderId: '428601249657',
    projectId: 'holbegram-e8b78',
    authDomain: 'holbegram-e8b78.firebaseapp.com',
    storageBucket: 'holbegram-e8b78.appspot.com',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? 'fallback_api_key',
    appId: '1:428601249657:android:85f48337d3cf1ac498e9a8',
    messagingSenderId: '428601249657',
    projectId: 'holbegram-e8b78',
    storageBucket: 'holbegram-e8b78.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? 'fallback_api_key',
    appId: '1:428601249657:ios:49e3b1aad4021a0598e9a8',
    messagingSenderId: '428601249657',
    projectId: 'holbegram-e8b78',
    storageBucket: 'holbegram-e8b78.appspot.com',
    iosBundleId: 'com.holbegram.holbegram',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? 'fallback_api_key',
    appId: '1:428601249657:ios:49e3b1aad4021a0598e9a8',
    messagingSenderId: '428601249657',
    projectId: 'holbegram-e8b78',
    storageBucket: 'holbegram-e8b78.appspot.com',
    iosBundleId: 'com.holbegram.holbegram',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? 'fallback_api_key',
    appId: '1:428601249657:windows:1234567890abcdef',
	messagingSenderId: '428601249657',
    projectId: 'holbegram-e8b78',
    storageBucket: 'holbegram-e8b78.appspot.com',
  );
}
