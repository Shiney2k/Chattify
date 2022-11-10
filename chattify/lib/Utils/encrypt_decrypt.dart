import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class Encryption_Management {
//-----------FOR RSA Assymettric Encription------------

  static encryptWithRSAPubKey(String key, String data) {
    final helper = RsaKeyHelper();
    RSAPublicKey pubKey = helper.parsePublicKeyFromPem(key);
    String encryptedData = encrypt(data, pubKey);
    return encryptedData;
  }

  static decryptWithRSAPrivKey(String key, String data) {
    final helper = RsaKeyHelper();
    RSAPrivateKey privKey = helper.parsePrivateKeyFromPem(key);
    String decryptedData = decrypt(data, privKey);
    return decryptedData;
  }

//-----------FOR AES Symettric Encription------------

  // static encryptWithAESKey(String key, String data) {
  //   dynamic keyArr = key.split(":");
  //   crypto.Key aesKey = crypto.Key.fromBase64(keyArr[0]);
  //   final encrypter = crypto.Encrypter(crypto.AES(aesKey));
  //   crypto.Encrypted encryptedData =
  //       encrypter.encrypt(data, iv: crypto.IV.fromBase64(keyArr[1]));
  //   return encryptedData.base64;
  // }

  // static decryptWithAESKey(String key, String data) {
  //   dynamic keyArr = key.split(":");
  //   crypto.Key aesKey = crypto.Key.fromBase64(keyArr[0]);
  //   final encrypter = crypto.Encrypter(crypto.AES(aesKey));
  //   crypto.Encrypted encrypted = crypto.Encrypted.fromBase64(data);
  //   String decryptedData =
  //       encrypter.decrypt(encrypted, iv: crypto.IV.fromBase64(keyArr[1]));
  //   return decryptedData;
  //}
}
