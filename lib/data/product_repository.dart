import '../domain/product.dart';
import 'product_api.dart';

class ProductRepository {
  const ProductRepository(this._api);

  final ProductApi _api;

  Future<List<Product>> getProducts() {
    return _api.getProducts();
  }
}
