import 'package:chattify/Screens/login_screen.dart';
import 'package:chattify/Utils/rsa_key_cryptography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(
    String name, String email, String password, String phone) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    userCrendetial.user!.updateDisplayName(name);

    RSAKeyManagement keypair = new RSAKeyManagement();
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "phone": phone,
      "date": DateTime.now(),
      "pubkey": keypair.getPubKey(),
      "pvtkey": keypair.getPvtKey(),
      "uid": _auth.currentUser!.uid,
    });

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_auth.currentUser!.uid)
    //     .set({"pvtkey":keyManagement.getPvtKey(),
    // });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print("error");
  }
}
