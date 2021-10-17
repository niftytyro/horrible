import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

final storage = Storage();

class Storage {
  final _secureStorage = const FlutterSecureStorage();
  final _storage = LocalStorage("data.json");

  Future<String?> get jwt {
    return _secureStorage.read(key: "jwt");
  }

  Future<void> setJwt(String token) async {
    await _secureStorage.write(key: "jwt", value: token);
  }

  String? get name {
    return _storage.getItem("name");
  }

  int get id {
    return _storage.getItem("id");
  }

  Future<void> setUserDetails({
    required int id,
    required String name,
    required String email,
    required String username,
    required String bio,
  }) async {
    await _storage.setItem("id", id);
    await _storage.setItem("bio", bio);
    await _storage.setItem("email", email);
    await _storage.setItem("name", name);
    await _storage.setItem("userame", username);
  }
}
