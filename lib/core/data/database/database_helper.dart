import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Database helper for SQLite operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  /// Database name
  static const String _databaseName = 'news_insight.db';
  static const int _databaseVersion = 1;

  /// Table names
  static const String favoritesTable = 'favorites';

  /// Column names for favorites table
  static const String columnId = 'id';
  static const String columnSourceId = 'source_id';
  static const String columnSourceName = 'source_name';
  static const String columnAuthor = 'author';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnUrl = 'url';
  static const String columnUrlToImage = 'url_to_image';
  static const String columnPublishedAt = 'published_at';
  static const String columnContent = 'content';
  static const String columnBookmarkedAt = 'bookmarked_at';

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoritesTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnSourceId TEXT,
        $columnSourceName TEXT NOT NULL,
        $columnAuthor TEXT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT,
        $columnUrl TEXT NOT NULL UNIQUE,
        $columnUrlToImage TEXT,
        $columnPublishedAt TEXT NOT NULL,
        $columnContent TEXT,
        $columnBookmarkedAt TEXT NOT NULL
      )
    ''');

    // Create index on URL for faster lookups
    await db.execute('''
      CREATE INDEX idx_url ON $favoritesTable($columnUrl)
    ''');

    // Create index on bookmarked_at for sorting
    await db.execute('''
      CREATE INDEX idx_bookmarked_at ON $favoritesTable($columnBookmarkedAt DESC)
    ''');
  }

  /// Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here if needed in future versions
    if (oldVersion < 2) {
      // Example: Add new column in version 2
      // await db.execute('ALTER TABLE $favoritesTable ADD COLUMN new_column TEXT');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    await deleteDatabase(path);
    _database = null;
  }

  Future<int> clearTable(String tableName) async {
    final db = await database;
    return await db.delete(tableName);
  }
}
