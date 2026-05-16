import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Firebase.apps.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Firebase is not configured yet'),
              ),
            )
          : orders.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No orders yet'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final order = items[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('\$${order.total.toStringAsFixed(2)}'),
                        subtitle: Text('${order.itemsCount} items'),
                        trailing: Text(
                          '${order.createdAt.day}.${order.createdAt.month}.${order.createdAt.year}',
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Center(child: Text('$error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
