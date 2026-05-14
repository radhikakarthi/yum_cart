// ─────────────────────────────────────────────────────────────────────────────
// providers/cart_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/menu_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => Map.unmodifiable(_items);

  int get totalItemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  int quantityFor(int dishId) => _items[dishId]?.quantity ?? 0;

  void increment(Dish dish) {
    if (_items.containsKey(dish.id)) {
      _items[dish.id]!.quantity++;
    } else {
      _items[dish.id] = CartItem(dish: dish);
    }
    notifyListeners();
  }

  void decrement(int dishId) {
    if (!_items.containsKey(dishId)) return;
    if (_items[dishId]!.quantity <= 1) {
      _items.remove(dishId);
    } else {
      _items[dishId]!.quantity--;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
