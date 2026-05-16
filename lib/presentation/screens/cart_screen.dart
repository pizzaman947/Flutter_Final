import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider).values.toList();
    final total = cart.fold<double>(0, (sum, item) => sum + item.total);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cart.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item.product.thumbnail,
                      width: 54,
                      fit: BoxFit.contain,
                    ),
                    title: Text(item.product.title),
                    subtitle: Text(
                      '${item.count} x \$${item.product.price.toStringAsFixed(2)}',
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .remove(item.product);
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).add(item.product);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () async {
                    try {
                      await ref.read(orderRepositoryProvider).createOrder(cart);
                      ref.read(cartProvider.notifier).clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order saved')),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('$error')));
                      }
                    }
                  },
                  child: Text('Place order: \$${total.toStringAsFixed(2)}'),
                ),
              ),
            ),
    );
  }
}
