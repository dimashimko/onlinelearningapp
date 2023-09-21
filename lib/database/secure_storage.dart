import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDB {
  const SecureStorageDB._();

  static const SecureStorageDB instance = SecureStorageDB._();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // void _getStoredCards() async {
  //   for (int i = 0; i < 100; i++) {
  //     String? cardData = await secureStorage.read(key: 'card_$i');
  //     if (cardData != null) {
  //       Map<String, dynamic> cardJson = json.decode(cardData);
  //       CardModel card = CardModel(
  //         cardNumber: cardJson['cardNumber'],
  //         cardHolderName: cardJson['cardHolderName'],
  //         expiryDate: cardJson['expiryDate'],
  //       );
  //       cards.add(card);
  //     }
  //   }
  //   setState(() {});
  // }

  Future<String?> read({required String key}) async {
    String? cardData = await secureStorage.read(key: key);

    return cardData;
  }

  Future<void> write({
    required String key,
    required String? value,
  }) async {
    secureStorage.write(key: key, value: value);
  }
}
