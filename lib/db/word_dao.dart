import 'package:sqflite/sqflite.dart';
import '../model/word.dart';

// SQLを直接触る

class PersonDao {
  final Database db;

  PersonDao(this.db);

  Future<List<Person>> findAll() async {
    final records = await db.query('persons');
    return records.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> insert(Person person) async {
    /// return: id
    return await db.insert('persons', person.toMap());
  }

  Future<void> delete(int id) async {
    db.delete(
      'persons',
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}

class WordDao {
  final Database db;

  const WordDao(this.db);

  Future<List<Word>> findAll() async {
    final records = await db.query('words');
    return records.map((e) => Word.fromMap(e)).toList();
  }

  Future<int> insert(Word word) async {
    return await db.insert('words', word.toMap());
  }

  Future<void> delete(int id) async {
    await db.delete(
      'words',
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}