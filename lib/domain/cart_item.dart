import 'product.dart';

class CartItem {
  const CartItem({required this.product, required this.count});

  final Product product;
  final int count;

  double get total => product.price * count;
}
