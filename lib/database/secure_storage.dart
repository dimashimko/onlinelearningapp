import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDB {
  const SecureStorageDB._();

  static const SecureStorageDB instance = SecureStorageDB._();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> loadCards() async {
    String? cardData = await secureStorage.read(
      key: 'cards_',
    );

    return cardData;
  }

  Future<void> saveCards({
    required String? value,
  }) async {
    secureStorage.write(
      key: 'cards_',
      value: value,
    );
  }
}
