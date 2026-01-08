import 'dart:convert';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();

  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearUser();

  Future<void> setPending(bool value);
  Future<bool> isPending();

  Future<void> clearAll();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences _prefs;

  AuthLocalDatasourceImpl(this._prefs);

  // -------- TOKEN --------

  @override
  Future<void> cacheToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  @override
  Future<String?> getCachedToken() async {
    return _prefs.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  // -------- USER --------

  @override
  Future<void> cacheUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _prefs.setString(AppConstants.userKey, jsonEncode(userModel.toJson()));
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final jsonString = _prefs.getString(AppConstants.userKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      return UserModel.fromJson(userMap);
    } catch (e) {
      await clearUser();
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(AppConstants.userKey);
  }

  // -------- PENDING --------

  @override
  Future<void> setPending(bool value) async {
    await _prefs.setBool(AppConstants.pendingKey, value);
  }

  @override
  Future<bool> isPending() async {
    return _prefs.getBool(AppConstants.pendingKey) ?? false;
  }

  // -------- CLEAR ALL --------

  @override
  Future<void> clearAll() async {
    await Future.wait([
      _prefs.remove(AppConstants.tokenKey),
      _prefs.remove(AppConstants.userKey),
      _prefs.remove(AppConstants.locationKey),
      _prefs.setBool(AppConstants.pendingKey, false),
    ]);
  }
}