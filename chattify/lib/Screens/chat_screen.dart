import 'package:chattify/Utils/encrypt_decrypt.dart';
import 'package:chattify/Utils/user_model.dart';
import 'package:chattify/Widgets/message.dart';
import 'package:chattify/Widgets/msg_typing_txtfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendPubKey;

  const ChatScreen({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendPubKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 0, 150),
        title: Row(
          children: [
            Text(
              friendName,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 206, 206, 206),
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .collection('chats_with')
                    .doc(friendId)
                    .collection('messages')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              currentUser.uid;

                          return Message(
                              message:
                                  Encryption_Management.decryptWithRSAPrivKey(
                                      currentUser.pvtKey,
                                      snapshot.data.docs[index]['message']),
                              isMe: isMe);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(
              currentUser.uid, currentUser.pubKey, friendId, friendPubKey),
        ],
      ),
    );
  }
}
