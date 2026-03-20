import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  static const _key = 'favorite_gifs';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_key);
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      state = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> gif) async {
    final id = gif['id'];
    final isFavorite = state.any((item) => item['id'] == id);

    if (isFavorite) {
      state = state.where((item) => item['id'] != id).toList();
    } else {
      state = [...state, gif];
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state));
  }

  bool isFavorite(String id) {
    return state.any((item) => item['id'] == id);
  }
}
