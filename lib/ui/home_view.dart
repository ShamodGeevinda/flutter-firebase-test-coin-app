// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin/net/flutterfire.dart';
import 'package:coin/ui/authentication.dart';
import 'package:coin/ui/item_view.dart';
import '/net/api_methods.dart';
import '/ui/add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  TextEditingController _controller = TextEditingController();
  var choice = <String>['Home', 'Profile', 'Setting', 'Privacy', 'Contact'];

  @override
  initState() {
    updateValues();
  }

  updateValues() async {
    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == "bitcoin") {
        return (bitcoin * amount).toStringAsFixed(2);
      } else if (id == "ethereum") {
        return (ethereum * amount).toStringAsFixed(2);
      } else {
        return (tether * amount).toStringAsFixed(2);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Ballance'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Coins')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemView()),
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 5.0, left: 15.0, right: 15),
                            child: Container(
                                height: MediaQuery.of(context).size.height / 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.5),
                                  color: Colors.blue,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Coin: ${document.id}",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Price: ${getValue(document.id, document['Amount'])}",
                                      style: TextStyle(
                                        //fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    PopupMenuButton<int>(
                                        itemBuilder: (context) => [
                                              // popupmenu item 1
                                              PopupMenuItem(
                                                value: 1,
                                                // row has two child icon and text.
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit),
                                                    SizedBox(
                                                      // sized box with width 10
                                                      width: 10,
                                                    ),
                                                    Text("Edit")
                                                  ],
                                                ),
                                              ),
                                              // popupmenu item 2
                                              PopupMenuItem(
                                                value: 2,
                                                // row has two child icon and text
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(
                                                      // sized box with width 10
                                                      width: 10,
                                                    ),
                                                    Text("Delete")
                                                  ],
                                                ),
                                              ),
                                            ],
                                        offset: Offset(0, 10),
                                        color: Colors.blue[400],
                                        elevation: 2,
                                        onSelected: (value) async {
                                          if (value == 1) {
                                            openDialog(document.id,
                                                document["Amount"]);
                                          } else if (value == 2) {
                                            removeCoin(document.id);
                                          }
                                        }),
                                  ],
                                ))));
                  }).toList(),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future openDialog(String id, double num) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Edit Coin Amount"),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(hintText: num.toString()),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await updateCoin(id, _controller.text);
                  Navigator.of(context).pop();
                },
                child: Text("Submit"))
          ],
        ),
      );
}
