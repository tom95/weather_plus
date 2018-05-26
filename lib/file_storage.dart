

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileStorage {
  static FirebaseStorage _instance;

  static void initialize(FirebaseApp app) {
    _instance = new FirebaseStorage(
        app: app,
        storageBucket: 'gs://weatherplus-2bfb7.appspot.com'
    );
  }

  static FirebaseStorage instance() {
    return _instance;
  }
}
