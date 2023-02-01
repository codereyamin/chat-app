import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_rome_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChartRoomModel chartRoomModel;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chartRoomModel,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    if (msg != "") {
      MessageModel newMessageModel = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(widget.chartRoomModel.chatRoomId)
          .collection("messages")
          .doc(newMessageModel.messageId)
          .set(newMessageModel.toMap());

      widget.chartRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(widget.chartRoomModel.chatRoomId)
          .set(widget.chartRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            backgroundImage:
                NetworkImage(widget.targetUser.profilepic.toString()),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.targetUser.fullName.toString(),
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
      body: SafeArea(
          child: Container(
        child: Column(children: [
          // chats list
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("ChatRooms")
                  .doc(widget.chartRoomModel.chatRoomId)
                  .collection("messages")
                  .orderBy("createdon", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel currentMessage = MessageModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Row(
                          mainAxisAlignment:
                              (currentMessage.sender == widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? Colors.blueGrey
                                        : Theme.of(context).primaryColor),
                                child: Text(
                                  currentMessage.text.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          "An Error occured! please check your internet connection"),
                    );
                  } else {
                    return const Center(
                      child: Text("Say hi to your new Firend"),
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

          // send funcation
          Container(
            color: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(children: [
              Flexible(
                  child: TextField(
                maxLines: null,
                controller: messageController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Message",
                ),
              )),
              IconButton(
                  onPressed: () {
                    sendMessage();
                    messageController.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  )),
            ]),
          )
        ]),
      )),
    );
  }
}
