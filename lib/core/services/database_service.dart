import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/community/models/character.dart';
import '../../features/chat/models/message.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'gony_chat.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE characters(
            id TEXT PRIMARY KEY,
            name TEXT,
            imageUrl TEXT,
            description TEXT,
            creatorName TEXT,
            creatorAvatarUrl TEXT,
            chatCount TEXT,
            tags TEXT,
            role TEXT,
            scenario TEXT,
            isPremium INTEGER,
            starRating INTEGER,
            background TEXT,
            relationship TEXT,
            personality TEXT,
            plot TEXT,
            appearance TEXT,
            identity TEXT,
            ability TEXT,
            introduction TEXT,
            greeting TEXT,
            isFavorite INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE messages(
            id TEXT PRIMARY KEY,
            charId TEXT,
            text TEXT,
            isUser INTEGER,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE characters ADD COLUMN background TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN relationship TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN personality TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN plot TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN appearance TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN identity TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN ability TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN introduction TEXT');
          await db.execute('ALTER TABLE characters ADD COLUMN greeting TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE characters ADD COLUMN isFavorite INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<void> insertCharacter(Character character) async {
    final db = await database;
    await db.insert('characters', character.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Character>> getCharacters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('characters');
    return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
  }

  Future<void> deleteAllCharacters() async {
    final db = await database;
    await db.delete('characters');
  }

  Future<void> incrementChatCount(String charId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'characters',
      columns: ['chatCount'],
      where: 'id = ?',
      whereArgs: [charId],
    );
    if (result.isNotEmpty) {
      int current = int.tryParse(result.first['chatCount'] as String) ?? 0;
      int newCount = current + 1;
      await db.update(
        'characters',
        {'chatCount': newCount.toString()},
        where: 'id = ?',
        whereArgs: [charId],
      );
    }
  }

  Future<void> updateCharacterFavorite(String charId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'characters',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [charId],
    );
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Message>> getMessages(String charId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'charId = ?',
      whereArgs: [charId],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  Future<void> deleteCharacter(String charId) async {
    final db = await database;
    await db.delete('characters', where: 'id = ?', whereArgs: [charId]);
    await db.delete('messages', where: 'charId = ?', whereArgs: [charId]);
  }

  Future<List<Map<String, dynamic>>> getChatList() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT c.*, 
           (SELECT text FROM messages WHERE charId = c.id ORDER BY timestamp DESC LIMIT 1) as lastMessage,
           (SELECT timestamp FROM messages WHERE charId = c.id ORDER BY timestamp DESC LIMIT 1) as lastMessageTime
    FROM characters c
    WHERE EXISTS (SELECT 1 FROM messages WHERE charId = c.id)
    ORDER BY lastMessageTime DESC
  ''');
    return result;
  }
}