import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';

class FavoritesRepository with ChangeNotifier {
  static const _favoritesKey = 'favorites';
  late SharedPreferences _prefs;
  List<Character> _favorites = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favoritesJson = _prefs.getStringList(_favoritesKey) ?? [];
      _favorites =
          favoritesJson.map((json) {
            final map = jsonDecode(json) as Map<String, dynamic>;
            return Character.fromJson(map);
          }).toList();
      notifyListeners();
    } catch (e) {
      await _prefs.remove(_favoritesKey);
      _favorites = [];
      debugPrint('Erro ao carregar favoritos: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final favoritesJson =
          _favorites.map((character) {
            return jsonEncode(character.toJson());
          }).toList();
      await _prefs.setStringList(_favoritesKey, favoritesJson);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar favoritos: $e');
    }
  }

  List<Character> get favorites => _favorites;

  Future<void> addFavorite(Character character) async {
    if (!_favorites.any((c) => c.id == character.id)) {
      _favorites.add(character);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(int characterId) async {
    _favorites.removeWhere((c) => c.id == characterId);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(int characterId) {
    return _favorites.any((c) => c.id == characterId);
  }
}
