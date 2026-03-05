import 'package:sqflite/sqflite.dart';

import '../../../../core/data/database/database_helper.dart';
import '../../../../core/data/error/exceptions.dart';
import '../../../home/data/models/article_model.dart';

abstract class FavoritesLocalDataSource {
  /// Insert article to favorites
  Future<void> insertArticle(ArticleModel article);

  /// Delete article from favorites by URL
  Future<void> deleteArticle(String url);

  /// Get all favorite articles
  Future<List<ArticleModel>> getAllFavorites();

  /// Check if article is favorited
  Future<bool> isFavorite(String url);

  /// Clear all favorites
  Future<void> clearAll();

  /// Get favorites count
  Future<int> getFavoritesCount();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final DatabaseHelper _databaseHelper;

  FavoritesLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<void> insertArticle(ArticleModel article) async {
    try {
      final db = await _databaseHelper.database;

      final data = article.toDatabase();
      data[DatabaseHelper.columnBookmarkedAt] = DateTime.now()
          .toIso8601String();

      await db.insert(
        DatabaseHelper.favoritesTable,
        data,
        // If conflict (URL already exists), replace it
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(
        'Failed to add article to favourites: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteArticle(String url) async {
    try {
      final db = await _databaseHelper.database;

      final deletedRows = await db.delete(
        DatabaseHelper.favoritesTable,
        where: '${DatabaseHelper.columnUrl} = ?',
        whereArgs: [url],
      );

      if (deletedRows == 0) {
        throw CacheException('Article not found in favorites');
      }
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        'Failed to delete article from favorites: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ArticleModel>> getAllFavorites() async {
    try {
      final db = await _databaseHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.favoritesTable,
        orderBy: '${DatabaseHelper.columnBookmarkedAt} DESC',
      );

      return maps.map((map) => ArticleModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException('Failed to load favorites: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String url) async {
    try {
      final db = await _databaseHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.favoritesTable,
        where: '${DatabaseHelper.columnUrl} = ?',
        whereArgs: [url],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      throw CacheException('Failed to check favorite status: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _databaseHelper.clearTable(DatabaseHelper.favoritesTable);
    } catch (e) {
      throw CacheException('Failed to clear favorites: ${e.toString()}');
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final db = await _databaseHelper.database;

      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${DatabaseHelper.favoritesTable}',
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw CacheException('Failed to get favorites count: ${e.toString()}');
    }
  }
}
