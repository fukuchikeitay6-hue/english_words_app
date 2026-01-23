import 'package:flutter/material.dart';
import 'package:sql2/db/word_dao.dart';
import '../model/word.dart';
import '../repository/word_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'components.dart';

class Homepage extends StatefulWidget {

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Database _database;
  late WordRepository _repo;
  final TextEditingController _controller = TextEditingController();

  List<Word> words = [];

  Future<void> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'create table words(id integer primary key autoincrement, word text, translation text)'
        );
      },
    );
  }

  Future<void> _setup() async {
    await _initDatabase();  // databaseの初期化はawaitしてから
    _repo = WordRepository(WordDao(_database));
    final list = await _repo.getAllWords();
    setState(() {  // setStateの中にawaitを書かない
      words = list;
    });
  }

  @override
  void initState() {  // initStateはasyncにしない
    super.initState();
    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SQL APP2',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      label: Text('単語を入力'),
                      border: OutlineInputBorder()
                    ),
                  )
                  ),
                  SizedBox(width: 16,),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final String word = _controller.text;
                    await _repo.addWord(Word(word));
                    final list = await _repo.getAllWords();
                    setState(() {  // setStateの中にawaitを書かない
                      words = list;
                    });
                    _controller.clear();
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0,),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  print(words[index].id);
                  return WordTile(
                    word: word,
                    onDelete: () async {
                      await _repo.removeWord(word);
                      final list = await _repo.getAllWords();
                      setState(() {
                        words = list;
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}