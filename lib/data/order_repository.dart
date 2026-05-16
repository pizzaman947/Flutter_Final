import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../domain/cart_item.dart';
import '../domain/order.dart';

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore? get firestore {
    if (Firebase.apps.isEmpty) return null;
    return _firestore ?? FirebaseFirestore.instance;
  }

  Future<void> createOrder(List<CartItem> items) async {
    final db = firestore;
    if (db == null) {
      throw Exception('Firebase is not configured');
    }

    final total = items.fold<double>(0, (result, item) => result + item.total);
    final count = items.fold<int>(0, (result, item) => result + item.count);

    await db.collection('orders').add({
      'total': total,
      'itemsCount': count,
      'createdAt': FieldValue.serverTimestamp(),
      'items': items
          .map(
            (item) => {
              'id': item.product.id,
              'title': item.product.title,
              'count': item.count,
              'price': item.product.price,
            },
          )
          .toList(),
    });
  }

  Stream<List<ShopOrder>> watchOrders() {
    final db = firestore;
    if (db == null) {
      return const Stream.empty();
    }

    return db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final createdAt = data['createdAt'];
            return ShopOrder(
              id: doc.id,
              total: (data['total'] as num).toDouble(),
              itemsCount: data['itemsCount'] as int,
              createdAt: createdAt is Timestamp
                  ? createdAt.toDate()
                  : DateTime.now(),
            );
          }).toList(),
        );
  }
}
