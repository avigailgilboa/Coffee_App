import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsgiIBnG9xI69boCvUUsKbFM22ZwZoavE',
    appId: '1:1057247779452:android:bceb280d1a9ec91ef147f9',
    projectId: 'coffee-app-5debd',
    messagingSenderId: '1057247779452',
    storageBucket: 'coffee-app-5debd.appspot.com'
  
  );
}
