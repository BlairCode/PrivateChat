import 'package:sqflite/sqflite.dart';
import 'package:private_chat/models/message.dart';

/// Service class for managing local SQLite database operations.
class DatabaseService {
  static Database? _db;
  static const String _dbName = 'chat.db';
  static const String _tableName = 'messages';

  /// Singleton getter for the database instance.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// Initializes the SQLite database and creates the messages table if it doesn't exist.
  Future<Database> _initDatabase() async {
    try {
      final String path = '${await getDatabasesPath()}/$_dbName';
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              content TEXT NOT NULL,
              isSentByMe INTEGER NOT NULL,
              timestamp TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  /// Inserts a message into the database.
  Future<void> insertMessage(Message msg) async {
    try {
      final db = await database;
      await db.insert(_tableName, {
        'content': msg.content,
        'isSentByMe': msg.isSentByMe ? 1 : 0,
        'timestamp': msg.timestamp.toIso8601String(),
      });
    } catch (e) {
      throw DatabaseException('Failed to insert message: $e');
    }
  }

  /// Retrieves all messages from the database.
  Future<List<Message>> getMessages() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(
        maps.length,
        (i) => Message(
          id: maps[i]['id'],
          content: maps[i]['content'],
          isSentByMe: maps[i]['isSentByMe'] == 1,
          timestamp: DateTime.parse(maps[i]['timestamp']),
        ),
      );
    } catch (e) {
      throw DatabaseException('Failed to retrieve messages: $e');
    }
  }

  /// Deletes all messages and resets the database.
  Future<void> deleteAllMessages() async {
    try {
      final db = await database;
      await db.delete(_tableName); // Delete all rows
      // Optionally reset the database by closing and deleting (uncomment if needed)
      // await db.close();
      // await deleteDatabase('${await getDatabasesPath()}/$_dbName');
      // _db = null;
    } catch (e) {
      throw DatabaseException('Failed to delete messages: $e');
    }
  }
}

/// Custom exception for database-related errors.
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}
