import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/app_database.dart';
import 'data/order_repository.dart';
import 'data/product_api.dart';
import 'data/product_repository.dart';
import 'domain/cart_item.dart';
import 'domain/product.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ProductApi());
});

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final favoritesProvider = StreamProvider<List<Favorite>>((ref) {
  return ref.watch(databaseProvider).watchFavorites();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final ordersProvider = StreamProvider((ref) {
  return ref.watch(orderRepositoryProvider).watchOrders();
});

final themeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final dark = prefs.getBool('darkTheme') ?? false;
    return dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('darkTheme', value);
    state = value ? ThemeMode.dark : ThemeMode.light;
  }
}

final cartProvider = NotifierProvider<CartController, Map<int, CartItem>>(
  CartController.new,
);

class CartController extends Notifier<Map<int, CartItem>> {
  @override
  Map<int, CartItem> build() {
    return {};
  }

  void add(Product product) {
    final current = state[product.id];
    state = {
      ...state,
      product.id: CartItem(product: product, count: (current?.count ?? 0) + 1),
    };
  }

  void remove(Product product) {
    final current = state[product.id];
    if (current == null) return;

    final next = {...state};
    if (current.count <= 1) {
      next.remove(product.id);
    } else {
      next[product.id] = CartItem(product: product, count: current.count - 1);
    }
    state = next;
  }

  void clear() {
    state = {};
  }
}
