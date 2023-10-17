import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBONb_9ziKyiL-XpSAkiZAkqR0aZ-gIIu4',
    appId: '1:488434172670:android:2be84e5b5fbc2ff0e55baf',
    messagingSenderId: '488434172670',
    projectId: 'onlinelearningapp-616fe',
    storageBucket: 'onlinelearningapp-616fe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGBCYHHbchwG6ntcpUlyH9IyjrMgmRTXg',
    appId: '1:488434172670:ios:b77227569ba78bd4e55baf',
    messagingSenderId: '488434172670',
    projectId: 'onlinelearningapp-616fe',
    storageBucket: 'onlinelearningapp-616fe.appspot.com',
    iosClientId:
        '488434172670-tcmqds43j868j4n48thirhvqbp1at9vh.apps.googleusercontent.com',
    iosBundleId: 'com.example.onlineLearningApp',
  );
}
