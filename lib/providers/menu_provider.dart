// ─────────────────────────────────────────────────────────────────────────────
// providers/menu_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<MenuCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMenu() async {
    if (_categories.isNotEmpty) return; // already loaded
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://faheemkodi.github.io/mock-menu-api/menu.json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _categories = (data['categories'] as List)
            .map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = 'Failed to load menu (${response.statusCode})';
      }
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
