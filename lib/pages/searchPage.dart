import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(labelText: "Email Address"),
          ),
          SizedBox(
            height: 30,
          ),
          CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: const Text("Search"),
              onPressed: () {}),
          SizedBox(
            height: 30,
          ),
        ]),
      )),
    );
  }
}
