//-----------FOR AES Symmetric key criptography------------

import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'dart:math';

class AESKeyManagement {
  dynamic iv;
  String key = "";

  AESKeyManagement() {
    AES key = generateAESKey();
    IV iv = IV.fromSecureRandom(16);
    String keyBase64 = key.key.base64;
    String ivBase64 = iv.base64;
    this.key = "$keyBase64:$ivBase64";
  }

  generateAESKey() {
    final key = Key.fromSecureRandom(32);
    print(Key.fromSecureRandom(32));
    return AES(key);
  }

  getAESKey() {
    return this.key;
  }
}
