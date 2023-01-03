import 'package:chat_app/pages/complete_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Chat App",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Enter Your Email"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Enter Your Password"),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                obscureText: true,
                decoration:
                    InputDecoration(labelText: "Enter Your Confirm Password"),
              ),
              SizedBox(
                height: 30,
              ),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text("Sign Up"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompletProfile(),
                        ));
                  })
            ],
          )),
        ),
      )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
