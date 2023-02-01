// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      // print("please fill all the fields!");
      UIHelper.showAlertDilog(
          context, "Incomplete Data", "Please fill all the fields!");
    } else {
      login(email, password);
    }
  }

  login(String email, String password) async {
    UserCredential? credential;
    UIHelper.showLodingDilog(context, "Log In....");
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      UIHelper.showAlertDilog(
          context, "An error occured", e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // Go to home page

      print("log in succesfull");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(
              userModel: userModel, firebaseUser: credential!.user!);
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: "Enter Your Email"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Enter Your Password"),
              ),
              const SizedBox(
                height: 30,
              ),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Text("Login"),
                  onPressed: () {
                    checkValues();
                  })
            ],
          )),
        ),
      )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
              child: const Text("Sign up"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
              })
        ],
      ),
    );
  }
}
