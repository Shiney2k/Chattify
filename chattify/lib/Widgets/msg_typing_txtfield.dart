import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chattify/Utils/encrypt_decrypt.dart';
import 'package:chattify/Utils/rsa_key_cryptography.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String currentUserPubKey;
  final String friendId;
  final String friendPubKey;

  MessageTextField(
      this.currentId, this.currentUserPubKey, this.friendId, this.friendPubKey);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Type your Message",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;

              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('chats_with')
                  .doc(widget.friendId)
                  .collection('messages')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": Encryption_Management.encryptWithRSAPubKey(
                    widget.currentUserPubKey, message),
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentId)
                    .collection('chats_with')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': Encryption_Management.encryptWithRSAPubKey(
                      widget.currentUserPubKey, message),
                  'time': DateTime.now(),
                });
              });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('chats_with')
                  .doc(widget.currentId)
                  .collection('messages')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": Encryption_Management.encryptWithRSAPubKey(
                    widget.friendPubKey, message),
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendId)
                    .collection('chats_with')
                    .doc(widget.currentId)
                    .set({
                  "last_msg": Encryption_Management.encryptWithRSAPubKey(
                      widget.friendPubKey, message),
                  'time': DateTime.now(),
                });
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
