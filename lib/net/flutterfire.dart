import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final storage = new FlutterSecureStorage();
  Future<bool> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      storetokenanddata(credential);
      print("shamod : 1 " + credential.toString());
      print("shamod : 2 " + credential.credential.toString());
      // print("shamod : 3 " + credential.credential!.token.toString());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // storetokenanddata(credential, storage);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addCoin(String id, String amount) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var value = double.parse(amount);
      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Coins')
              .doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(documentReference);
        if (!snapshot.exists) {
          documentReference.set({'Amount': value});
          return true;
        }

        try {
          double newAmount = snapshot.data()!['Amount'] + value;
          transaction.update(documentReference, {'Amount': newAmount});
          return true;
        } catch (e) {
          rethrow;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeCoin(String id) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Coins')
            .doc(id)
            .delete();
        return true;
      } else {
        throw ("This is my first general exception");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateCoin(String id, String amount) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var value = double.parse(amount);
      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Coins')
              .doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(documentReference);
        if (!snapshot.exists) {
          documentReference.set({'Amount': value});
          return true;
        }

        try {
          double newAmount = value;
          transaction.update(documentReference, {'Amount': newAmount});
          return true;
        } catch (e) {
          rethrow;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> storetokenanddata(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.user!.uid.toString());
    var val = userCredential.credential?.token;

    print("shamod : " + val.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
