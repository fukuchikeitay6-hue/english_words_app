import '../model/word.dart';
import '../db/word_dao.dart';

class PersonRepository {
  final PersonDao dao;

  PersonRepository(this.dao);

  Future<List<Person>> getAllPersons() {
    return dao.findAll();
  }

  Future<void> addPerson(Person person) async {
    final id = await dao.insert(person);
    person.id = id;
  }

  Future<void> removePerson(Person person) async {
    if (person.id == null) return;
    await dao.delete(person.id!);
  }
}

class WordRepository {
  final WordDao dao;

  const WordRepository(this.dao);

  Future<List<Word>> getAllWords() async {
    return dao.findAll();
  }

  Future<void> addWord(Word word) async {
    final id = await dao.insert(word);
    word.id = id;
  }

  Future<void> removeWord(Word word) async {
    if (word.id == null) return;
    await dao.delete(word.id!);
  }
}