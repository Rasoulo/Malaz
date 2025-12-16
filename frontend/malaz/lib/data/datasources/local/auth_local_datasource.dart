import 'dart:convert';

import 'package:malaz/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user_entity.dart';

abstract class AuthLocalDatasource {
  // TOKEN
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();

  // USER
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearUser();

  // PENDING
  Future<void> setPending(bool value);
  Future<bool> isPending();

  // CLEAR ALL
  Future<void> clearAll();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences prefs;

  static const _KEY_TOKEN = 'CACHED_TOKEN';
  static const _KEY_USER = 'CACHED_USER';
  static const _KEY_PENDING = 'IS_PENDING';

  AuthLocalDatasourceImpl(this.prefs);

  // -------- TOKEN --------

  @override
  Future<void> cacheToken(String token) async {
    await prefs.setString(_KEY_TOKEN, token);
  }

  @override
  Future<String?> getCachedToken() async {
    return prefs.getString(_KEY_TOKEN);
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove(_KEY_TOKEN);
  }

  // -------- USER --------

  @override
  Future<void> cacheUser(UserEntity user) async {
    final jsonString = jsonEncode(UserModel.fromEntity(user).toJson());
    await prefs.setString(_KEY_USER, jsonString);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final jsonString = prefs.getString(_KEY_USER);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(_KEY_USER);
  }

  // -------- PENDING --------

  @override
  Future<void> setPending(bool value) async {
    await prefs.setBool(_KEY_PENDING, value);
  }

  @override
  Future<bool> isPending() async {
    return prefs.getBool(_KEY_PENDING) ?? false;
  }

  // -------- CLEAR ALL --------

  @override
  Future<void> clearAll() async {
    await clearToken();
    await clearUser();
    await setPending(false);
  }
}
