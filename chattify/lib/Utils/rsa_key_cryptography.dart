import 'dart:io';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

class RSAKeyManagement {
  String pubKey = "";
  String privKey = "";

  RSAKeyManagement() {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final helper = RsaKeyHelper();
    pubKey = helper.encodePublicKeyToPemPKCS1(pair.publicKey);
    privKey = helper.encodePrivateKeyToPemPKCS1(pair.privateKey);
  }

  String getPubKey() {
    return pubKey;
  }

  String getPvtKey() {
    return privKey;
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    final pair = keyGen.generateKeyPair();
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom exampleSecureRandom() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    return secureRandom;
  }
}
