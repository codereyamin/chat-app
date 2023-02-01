import 'package:chat_app/firebase/firebaseHelper.dart';
import 'package:chat_app/models/chat_rome_model.dart';
import 'package:chat_app/models/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room_page.dart';
import 'package:chat_app/pages/searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Chat App"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SafeArea(
            child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("ChatRooms")
                .where("participants.${widget.userModel.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChartRoomModel chartRoomModel = ChartRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chartRoomModel.participants!;
                      List<String> participantsKeys =
                          participants.keys.toList();
                      participantsKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(
                            participantsKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              return ListTile(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoomPage(
                                          targetUser: targetUser,
                                          chartRoomModel: chartRoomModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser);
                                    },
                                  ));
                                },
                                title: Text(targetUser.fullName.toString()),
                                subtitle: (chartRoomModel.lastMessage
                                            .toString() !=
                                        "")
                                    ? Text(
                                        chartRoomModel.lastMessage.toString(),
                                      )
                                    : const Text("send new message to friend!"),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        targetUser.profilepic.toString())),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser),
                ));
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
