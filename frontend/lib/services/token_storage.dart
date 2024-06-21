import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'access', value: accessToken);
    await _secureStorage.write(key: 'refresh', value: refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _secureStorage.write(key: 'access', value: accessToken);
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: 'userId', value: userId);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh');
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'userId');
  }

  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: 'access');
    await _secureStorage.delete(key: 'refresh');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    for (var key in userData.keys) {
      await _secureStorage.write(key: key, value: userData[key].toString());
    }
  }

  Future<Map<String, String>> getUserData() async {
    final allValues = await _secureStorage.readAll();
    return allValues;
  }

  Future<void> deleteUserData() async {
    final allValues = await _secureStorage.readAll();
    for (var key in allValues.keys) {
      await _secureStorage.delete(key: key);
    }
  }
}
