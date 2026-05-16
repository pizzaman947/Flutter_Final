import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved products')),
      body: favorites.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No saved products yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    item.thumbnail,
                    width: 54,
                    fit: BoxFit.contain,
                  ),
                  title: Text(item.title),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    onPressed: () {
                      ref.read(databaseProvider).deleteFavorite(item.id);
                    },
                    icon: const Icon(Icons.delete_outline),
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
