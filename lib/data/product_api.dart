import 'package:chopper/chopper.dart';

import '../domain/product.dart';

class ProductApi {
  ProductApi()
    : _client = ChopperClient(
        baseUrl: Uri.parse('https://dummyjson.com'),
        converter: const JsonConverter(),
      );

  final ChopperClient _client;

  Future<List<Product>> getProducts() async {
    final response = await _client
        .get<Map<String, dynamic>, Map<String, dynamic>>(
          Uri.parse('/products?limit=30'),
        );

    if (!response.isSuccessful || response.body == null) {
      throw Exception('Could not load products');
    }

    final items = response.body!['products'] as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
