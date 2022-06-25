import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(
          value: 0.8,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple),
        ));
  }
}
