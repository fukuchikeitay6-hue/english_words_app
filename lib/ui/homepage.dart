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
  List<Word> showWords = [];

  Future<void> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'create table words(id integer primary key autoincrement, word text, translation text, learnedCount integer, createdAt integer)'
        );
      },
    );
  }

  Future<void> _setup() async {
    await _initDatabase();  // databaseの初期化はawaitしてから
    _repo = WordRepository(WordDao(_database));
    getAllWords();
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

  void getAllWords() async {
    final list = await _repo.getAllWords();
    setState(() {
      words = list;
      setShowWords();
    });
  }

  void setShowWords() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        showWords = List.from(words);
      });
      return;
    }
    final list = words.where((w) => w.word.contains(text)).toList();
    setState(() {
      showWords = [...list, Word('$textを追加')];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '英単語帳',
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
                    onChanged: (value) {
                      setShowWords();
                    },
                  )
                  ),
                  SizedBox(width: 16,),
              ],
            ),
            SizedBox(height: 8.0,),
            Expanded(
              child: ListView.builder(
                itemCount: showWords.length,
                itemBuilder: (context, index) {
                  final word = showWords[index];
                  return WordTile(
                    word: word,
                    onTap: word.id == null 
                    ? () async {
                      final text = _controller.text;
                      final word = Word(text);
                      final Word? newWord = await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => NewWordPage(word: word))
                      );
                      if (newWord == null) {
                        _controller.clear();
                        getAllWords();
                        return;
                      }
                      await _repo.addWord(newWord);
                      _controller.clear();
                      getAllWords();
                    }
                    : () async {
                      await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => WordDetailPage(word: word, repo: _repo,))
                      );
                      _repo.update(word.copyWith(learnedCount: word.learnedCount + 1));
                      getAllWords();
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