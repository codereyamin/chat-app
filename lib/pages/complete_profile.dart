import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompletProfile extends StatefulWidget {
  const CompletProfile({super.key});

  @override
  State<CompletProfile> createState() => _CompletProfileState();
}

class _CompletProfileState extends State<CompletProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Complete Profile")),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(children: [
          SizedBox(
            height: 25,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: CircleAvatar(
              radius: 70,
              child: Icon(
                Icons.person,
                size: 70,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
              decoration: InputDecoration(
            labelText: "Full Name",
          )),
          SizedBox(
            height: 25,
          ),
          CupertinoButton(child: Text("Submit"), onPressed: () {})
        ]),
      )),
    );
  }
}
