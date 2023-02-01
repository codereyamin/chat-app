import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_rome_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController searchController = TextEditingController();
  Future<ChartRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChartRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .where("participants${widget.userModel.uid}", isEqualTo: true)
        .where("participants${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChartRoomModel existingChatroom =
          ChartRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      // create a new one
      ChartRoomModel newChatRoom =
          ChartRoomModel(chatRoomId: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });

      await FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
    }
    return chatRoom;
  }

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
            controller: searchController,
            decoration: const InputDecoration(labelText: "Email Address"),
          ),
          const SizedBox(
            height: 30,
          ),
          CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: const Text("Search"),
              onPressed: () {
                setState(() {});
              }),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email", isEqualTo: searchController.text)
                .where("email", isNotEqualTo: widget.userModel.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                  if (dataSnapshot.docs.length > 0) {
                    Map<String, dynamic> userMap =
                        dataSnapshot.docs[0].data() as Map<String, dynamic>;

                    UserModel searchUser = UserModel.fromMap(userMap);
                    return ListTile(
                      onTap: () async {
                        ChartRoomModel? chatRoomModel =
                            await getChatRoomModel(searchUser);
                        if (chatRoomModel != null) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomPage(
                                    chartRoomModel: chatRoomModel,
                                    firebaseUser: widget.firebaseUser,
                                    targetUser: searchUser,
                                    userModel: widget.userModel),
                              ));
                        }
                      },
                      title: Text(searchUser.fullName.toString()),
                      subtitle: Text(searchUser.email.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        backgroundImage: NetworkImage(searchUser.profilepic!),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    );
                  } else {
                    return const Text("No Results found!");
                  }
                } else if (snapshot.hasError) {
                  return const Text("An Error Occured");
                } else {
                  return const Text("No Results found!");
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ]),
      )),
    );
  }
}
