import 'dart:io';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompletProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompletProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompletProfile> createState() => _CompletProfileState();
}

class _CompletProfileState extends State<CompletProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickFile = await ImagePicker().pickImage(source: source);
    if (pickFile != null) cropImage(pickFile);
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (cropImage != null) {
      setState(() {
        imageFile = File(croppedImage!.path);
      });
    }
  }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                selectImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text("Select from gallery"),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                selectImage(ImageSource.camera);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Select from camera"),
            )
          ]),
        );
      },
    );
  }

  void chekvalues() {
    String fullname = fullNameController.text.trim();
    if (fullname == "" || imageFile == null) {
      print("Please file all the fields");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();
    widget.userModel.fullName = fullname;
    widget.userModel.profilepic = imageUrl;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      print("Data Uploaded!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Complete Profile")),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(children: [
          const SizedBox(
            height: 25,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showPhotoOption();
            },
            child: CircleAvatar(
              backgroundImage:
                  (imageFile != null) ? FileImage(imageFile!) : null,
              radius: 70,
              child: (imageFile == null)
                  ? const Icon(
                      Icons.person,
                      size: 70,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
              )),
          const SizedBox(
            height: 30,
          ),
          CupertinoButton(
              color: ThemeData().primaryColor,
              child: const Text("Submit"),
              onPressed: () {
                chekvalues();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return HomePage(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser);
                  },
                ));
              })
        ]),
      )),
    );
  }
}
