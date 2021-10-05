import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = SecureStorage();

class SecureStorage {
  final _secureStorage = const FlutterSecureStorage();

  get jwt {
    return _secureStorage.read(key: "jwt");
  }

  Future<void> setJwt(token) async {
    await _secureStorage.write(key: "jwt", value: token);
  }
}
