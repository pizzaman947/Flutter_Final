import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: products.when(
        data: (items) {
          final product = items.firstWhere((item) => item.id == productId);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: Image.network(product.thumbnail, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(product.category),
              const SizedBox(height: 12),
              Text(product.description),
              const SizedBox(height: 18),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => ref.read(cartProvider.notifier).add(product),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to cart'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(databaseProvider).toggleFavorite(product),
                icon: const Icon(Icons.favorite_border),
                label: const Text('Save product'),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
