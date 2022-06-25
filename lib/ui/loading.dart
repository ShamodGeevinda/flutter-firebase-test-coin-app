import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading....'),
      ),
      body: Container(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
