import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDB {
  const SecureStorageDB._();

  static const SecureStorageDB instance = SecureStorageDB._();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

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
