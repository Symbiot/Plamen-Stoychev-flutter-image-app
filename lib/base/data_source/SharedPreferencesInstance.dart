import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// This class is using as wrapper of SharedPreferences to avoid async
class SharedPreferencesInstance {
  static const String favoriteKey = 'imageFavorites';
  static const String searchKey = 'searchData';
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<bool> isFavorite(int elementId) async {
    List<String> currentList =
        (await _instance).getStringList(favoriteKey) ?? [];
    if (currentList.isEmpty) return false;
    return currentList.any((element) {
      return json.decode(element)['id'] == elementId;
    });
  }

  Future<List<String>> getAllFavorites() async {
    return (await _instance).getStringList(favoriteKey) ?? [];
  }

  Future<bool> addToFavorite(Map<String, dynamic> value) async {
    List<String> currentList =
        (await _instance).getStringList(favoriteKey) ?? [];
    currentList.add(json.encode(value));
    return (await _instance).setStringList(favoriteKey, currentList);
  }

  Future<bool> removeFromFavorite(int elementId) async {
    List<String> currentList =
        (await _instance).getStringList(favoriteKey) ?? [];
    currentList.removeWhere((element) {
      return json.decode(element)['id'] == elementId;
    });
    return (await _instance).setStringList(favoriteKey, currentList);
  }

  Future<String?> getFavorites(String key) async =>
      (await _instance).getString(key);

  Future<bool> clear() async => (await _instance).clear();

  Future<List<String>> getSearchStrings() async =>
      (await _instance).getStringList(searchKey) ?? [];

  Future<bool> setSearchString(String value) async {
    List<String> currentList = (await _instance).getStringList(searchKey) ?? [];
    bool haveSuch = currentList.any((item) => item == value);
    if (!haveSuch) currentList.add(value);
    return (await _instance).setStringList(searchKey, currentList);
  }
}
