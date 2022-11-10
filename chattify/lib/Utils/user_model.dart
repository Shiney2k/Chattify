import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String phone;
  Timestamp date;
  String pubKey;
  String pvtKey;
  String uid;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.date,
      required this.pubKey,
      required this.pvtKey,
      required this.uid});

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot['name'],
      email: snapshot['email'],
      phone: snapshot['phone'],
      date: snapshot['date'],
      pubKey: snapshot['pubkey'],
      pvtKey: snapshot['pvtkey'],
      uid: snapshot['uid'],
    );
  }
}
