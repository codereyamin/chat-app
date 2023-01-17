import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? usermodel;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (docSnap.data() != null) {
      usermodel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return usermodel;
  }
}
