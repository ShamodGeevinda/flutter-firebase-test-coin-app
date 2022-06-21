import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final storage = new FlutterSecureStorage();
}
