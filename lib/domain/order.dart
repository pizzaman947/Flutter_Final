class ShopOrder {
  const ShopOrder({
    required this.id,
    required this.total,
    required this.itemsCount,
    required this.createdAt,
  });

  final String id;
  final double total;
  final int itemsCount;
  final DateTime createdAt;
}
