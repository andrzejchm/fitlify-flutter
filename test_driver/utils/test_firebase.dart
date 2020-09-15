import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class TestFirebase {
  static Future<TestFirebase> initialize() async {
    final app = await Firebase.initializeApp(
        name: "test",
        options: const FirebaseOptions(
          apiKey: "AIzaSyCbrJq6DiAGrGn0UZQSY1KjpsrMz4Phjho",
          authDomain: "fitlify-staging.firebaseapp.com",
          appId: "1:831538621876:web:55fee3e0ec0865e19f56e1",
          messagingSenderId: "831538621876",
          projectId: "fitlify-staging",
          databaseURL: "https://fitlify-staging.firebaseio.com",
          storageBucket: "fitlify-staging.appspot.com",
        ));
    return TestFirebase._(app);
  }

  final FirebaseApp app;

  FirebaseFirestore get firestore => FirebaseFirestore.instanceFor(app: app);

  FirebaseAuth get auth => FirebaseAuth.instanceFor(app: app);

  TestFirebase._(this.app);

  Future<void> tearDown() => Firebase.app("test").delete();
}
