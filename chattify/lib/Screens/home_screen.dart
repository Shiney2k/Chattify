import 'package:chattify/Utils/auth_methods.dart';
import 'package:chattify/Utils/encrypt_decrypt.dart';
import 'package:chattify/Utils/user_model.dart';
import 'package:chattify/Screens/chat_screen.dart';
import 'package:chattify/Screens/chat_search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chattify : ${widget.user.name}'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 0, 150),
        actions: [
          IconButton(
              onPressed: () async {
                logOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .collection('chats_with')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text("No Chats Available !"),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        var friend = asyncSnapshot.data;
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 245, 245, 245)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(friend['name']),
                          tileColor: const Color.fromARGB(255, 255, 255, 255),
                          subtitle: Text(
                            Encryption_Management.decryptWithRSAPrivKey(
                                widget.user.pvtKey, "$lastMsg"),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          currentUser: widget.user,
                                          friendId: friend['uid'],
                                          friendName: friend['name'],
                                          friendPubKey: friend['pubkey'],
                                        )));
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 1,
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(widget.user)));
        },
      ),
    );
  }
}
