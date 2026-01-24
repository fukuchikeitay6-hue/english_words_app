import 'package:flutter/material.dart';

import '../model/word.dart';
import '../db/word_dao.dart';


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

  Future<void> incrementLearnedCount(Word word) async {
    if (word.id == null) return;
    await dao.update(
      word.copyWith(
        learnedCount: word.learnedCount + 1
      )
    );
  }
}