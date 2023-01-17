import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/complete_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (email == "" || password == "" || confirmPassword == "") {
      print("Please file all the fields!");
    } else if (password != confirmPassword) {
      print("Password do not match");
    } else {
      signUp(email, password);
    }
  }

  signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      print(e.code.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullName: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New User Created!");
        Navigator.push(context, MaterialPageRoute(builder: (contex) {
          return CompletProfile(
              userModel: newUser, firebaseUser: credential!.user!);
        }));
      });
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
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Enter Your Password"),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Enter Your Confirm Password"),
              ),
              const SizedBox(
                height: 30,
              ),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Text("Sign Up"),
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
            "Already have an account",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
              child: const Text("Login"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
