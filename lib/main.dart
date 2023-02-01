import 'package:chat_app/firebase/firebaseHelper.dart';
import 'package:chat_app/firebase/firebase_options.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // logged in
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyAppLoggdin(
        firebaseUser: currentUser,
        userModel: thisUserModel,
      ));
    } else {
      // if logged problem
      runApp(const MyApp());
    }
  } else {
    // not logged in
    runApp(const MyApp());
  }
}

// not logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

// already logged in
class MyAppLoggdin extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggdin(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(firebaseUser: firebaseUser, userModel: userModel),
    );
  }
}
