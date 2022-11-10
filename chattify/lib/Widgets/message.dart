import 'package:chattify/Utils/encrypt_decrypt.dart';
import 'package:chattify/Utils/rsa_key_cryptography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final bool isMe;
  Message({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(7),
            constraints: const BoxConstraints(maxWidth: 270),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color.fromARGB(255, 160, 210, 230)
                  : const Color.fromARGB(255, 1, 19, 75),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe
                    ? const Color.fromARGB(255, 2, 2, 2)
                    : const Color.fromARGB(255, 238, 239, 243),
              ),
            )),
      ],
    );
  }
}
