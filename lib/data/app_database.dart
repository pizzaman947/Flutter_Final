import 'package:drift/drift.dart';

import '../domain/product.dart';
import 'database_connection.dart';

part 'app_database.g.dart';

class Favorites extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  RealColumn get price => real()();
  TextColumn get thumbnail => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Favorite>> watchFavorites() {
    return select(favorites).watch();
  }

  Future<bool> isFavorite(int id) async {
    final row = await (select(
      favorites,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row != null;
  }

  Future<void> toggleFavorite(Product product) async {
    final exists = await isFavorite(product.id);
    if (exists) {
      await (delete(favorites)..where((tbl) => tbl.id.equals(product.id))).go();
      return;
    }

    await into(favorites).insert(
      FavoritesCompanion.insert(
        id: Value(product.id),
        title: product.title,
        price: product.price,
        thumbnail: product.thumbnail,
      ),
    );
  }

  Future<void> deleteFavorite(int id) async {
    await (delete(favorites)..where((tbl) => tbl.id.equals(id))).go();
  }
}
