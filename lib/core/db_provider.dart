import 'package:shared_preferences/shared_preferences.dart';

abstract class Cache {
  Future<String> getInSharedPreference(String key);
  Future<bool> getBoolInSharedPreference(String key);
  Future<int>? getIntInSharedPreference(String key);
  Future<bool> deleteInSharedPreference(String key);
  Future<bool> storeInSharedPreference(String key, dynamic value);
  Future<bool> storeIntInSharedPreference(String key, dynamic value);
  Future<bool> storeBoolInSharedPreference(String key, dynamic value);
}

class DBProvider implements Cache {
  /// {@template {DatabaseLocalProvider}}
  /// General exception for [`DatabaseLocalProvider`] methods.
  /// {@endtemplate}

  @override
  Future<bool> deleteInSharedPreference(String key) async {
    final storage = await SharedPreferences.getInstance();
    return storage.remove(key);
  }

  @override
  Future<bool> storeInSharedPreference(String key, dynamic value) async {
    final storage = await SharedPreferences.getInstance();

    return storage.setString(key, value);
  }

  @override
  Future<bool> storeIntInSharedPreference(String key, dynamic value) async {
    final storage = await SharedPreferences.getInstance();

    return storage.setInt(key, value);
  }

  @override
  Future<bool> storeBoolInSharedPreference(String key, dynamic value) async {
    final storage = await SharedPreferences.getInstance();

    return storage.setBool(key, value);
  }

  @override
  Future<String> getInSharedPreference(String key) async {
    final storage = await SharedPreferences.getInstance();

    return storage.getString(key) ?? '';
  }

  @override
  Future<int>? getIntInSharedPreference(String key) async {
    final storage = await SharedPreferences.getInstance();

    return storage.getInt(key) ?? 0;
  }

  @override
  Future<bool> getBoolInSharedPreference(String key) async {
    final storage = await SharedPreferences.getInstance();

    return storage.getBool(key) ?? false;
  }
}
