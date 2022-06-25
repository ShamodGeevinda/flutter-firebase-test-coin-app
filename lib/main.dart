import 'dart:io';

import 'package:coin/net/flutterfire.dart';
import 'package:coin/ui/home_view.dart';
import 'package:coin/ui/item_view.dart';
import 'package:coin/ui/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'ui/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = Loading();
  final storage = new FlutterSecureStorage();
  AuthClass auth = AuthClass();
  @override
  void initState() {
    // TODO: implement initState

    print("Shamod : above fn");
    checklogin();
    print("Shamod : below fn");
    super.initState();
  }

  void checklogin() async {
    String? token = await auth.getToken();
    print("Shamod : " + token.toString());
    if (token != null) {
      print("Shamod : login checking...");
      currentPage = HomeView();
      setState(() {});
    } else {
      currentPage = Authentication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
