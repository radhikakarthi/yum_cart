// ─────────────────────────────────────────────────────────────────────────────
// models/menu_model.dart
// ─────────────────────────────────────────────────────────────────────────────

class Addon {
  final int id;
  final String name;
  final String price;

  Addon({required this.id, required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json['id'] as int,
        name: json['name'] as String,
        price: json['price'] as String,
      );
}

class Dish {
  final int id;
  final String name;
  final String price;
  final String currency;
  final int calories;
  final String description;
  final List<Addon> addons;
  final String imageUrl;
  final bool customizationsAvailable;
  final bool isVeg;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.calories,
    required this.description,
    required this.addons,
    required this.imageUrl,
    required this.customizationsAvailable,
    required this.isVeg,
  });

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        id: json['id'] as int,
        name: json['name'] as String,
        price: json['price'] as String,
        currency: json['currency'] ?? 'INR',
        calories: json['calories'] as int,
        description: json['description'] as String,
        addons: (json['addons'] as List<dynamic>)
            .map((e) => Addon.fromJson(e as Map<String, dynamic>))
            .toList(),
        imageUrl: json['image_url'] as String,
        customizationsAvailable:
            json['customizations_available'] as bool? ?? false,
        isVeg: json['is_veg'] as bool? ?? false,
      );
}

class MenuCategory {
  final int id;
  final String name;
  final List<Dish> dishes;

  MenuCategory({required this.id, required this.name, required this.dishes});

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: json['id'] as int,
        name: json['name'] as String,
        dishes: (json['dishes'] as List<dynamic>)
            .map((e) => Dish.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class CartItem {
  final Dish dish;
  int quantity;

  CartItem({required this.dish, this.quantity = 1});

  double get totalPrice => double.parse(dish.price) * quantity;
}
