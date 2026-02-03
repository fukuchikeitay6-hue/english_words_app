import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'testpage.dart';
import 'newwordpage.dart';
import 'worddetailpage.dart';
import '../components/wordtile.dart';
import '../../db/word_dao.dart';
import '../../model/word.dart';
import '../../repository/word_repository.dart';

enum SortMode {
  alphabet,
  createdAt,
  learnedAt,
  learnedCount
}

enum SortOrder {
  /// 昇順
  ascending,
  /// 降順
  descending
}

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

  int currentPageIndex = 0;

  TestPhase testPagePhase = TestPhase.setting;

  final Map<String, dynamic> _setting = {
    'sortMode': SortMode.createdAt,
    'sortOrder': SortOrder.descending,
    'showTranslation': true,
    'showCreatedAt': true,
    'showLearnedAt': true,
    'showLearnedCount': true
  };

  // ソート機能
  /// wordsを並び替え
void sort() {
  final SortMode mode = _setting['sortMode'];
  final SortOrder order = _setting['sortOrder'];

  int compare(Word a, Word b) {
    int result;
    switch (mode) {
      case SortMode.alphabet:
        result = a.word.compareTo(b.word);
        break;
      case SortMode.createdAt:
        result = a.createdAt.compareTo(b.createdAt);
        break;
      case SortMode.learnedAt:
        result = a.learnedAt.compareTo(b.learnedAt);
        break;
      case SortMode.learnedCount:
        result = a.learnedCount.compareTo(b.learnedCount);
        break;
    }

    if (order == SortOrder.descending) {
      result = -result;
    }
    return result;
  }

  words.sort(compare);
}


  //TODO: UIの更新
  void onSetting() {
    sort();
    setShowWords();

  }

  Future<void> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'create table words(id integer primary key autoincrement, word text, translation text, learnedCount integer, createdAt integer, learnedAt integer)'
        );
      },
    );
  }

  Future<void> _setup() async {
    await _initDatabase();  // databaseの初期化はawaitしてから
    _repo = WordRepository(WordDao(_database));
    await getAllWords();
    onSetting();
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

  Future<void> getAllWords() async {
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
        actions: [
          IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context, 
                    builder: (context) => StatefulBuilder(
                      builder: (context, setDialogState) {
                        return SimpleDialog(
                          title: Text('表示設定'),
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: DropdownMenu(
                                requestFocusOnTap: false,
                                label: Text('表示順'),
                                initialSelection: _setting['sortMode'],
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: SortMode.alphabet, label: 'アルファベット順'),
                                  DropdownMenuEntry(value: SortMode.createdAt, label: '追加日順'),
                                  DropdownMenuEntry(value: SortMode.learnedAt, label: '学習日順'),
                                  DropdownMenuEntry(value: SortMode.learnedCount, label: '学習回数順'),
                                ],
                                onSelected: (newValue) {
                                  _setting.update('sortMode', (value) => newValue);
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            Center(
                              child: DropdownMenu(
                                requestFocusOnTap:  false,
                                label: Text('順序'),
                                initialSelection: _setting['sortOrder'],
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: SortOrder.ascending, label: '昇順'),
                                  DropdownMenuEntry(value: SortOrder.descending, label: '降順')
                                ],
                                onSelected: (newValue) {
                                  _setting.update('sortOrder', (value) => newValue);
                                },
                              ),
                            ),
                            SizedBox(height: 16,), 
                            Row(
                              spacing: 8.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('訳を表示'),
                                Switch(
                                  value: _setting['showTranslation'], 
                                  onChanged:(newValue) {
                                    setDialogState(() {
                                      _setting.update('showTranslation', (value) => newValue);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              spacing: 8.0,
                              mainAxisAlignment: .center,
                              children: [
                                Text('追加日を表示'),
                                Switch(
                                  value: _setting['showCreatedAt'], 
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      _setting.update('showCreatedAt', (value) => newValue);
                                    });
                                  }
                                )
                              ],
                            ),
                            Row(
                              spacing: 8.0,
                              mainAxisAlignment: .center,
                              children: [
                                Text('学習日を表示'),
                                Switch(
                                  value: _setting['showLearnedAt'], 
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      _setting.update('showLearnedAt', (value) => newValue);
                                    });
                                  }
                                )
                              ],
                            ),
                            Row(
                              spacing: 8.0,
                              mainAxisAlignment: .center,
                              children: [
                                Text('学習回数を表示'),
                                Switch(
                                  value: _setting['showLearnedCount'], 
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      _setting.update('showLearnedCount', (value) => newValue);
                                    });
                                  }
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    )
                  );
                  onSetting();
                }, 
                icon: Icon(Icons.more_vert),
              ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey.shade200,
        height: 60,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) async {
          if (testPagePhase == TestPhase.running && index != 1) {
            final bool? isInterruption = await showDialog<bool>(
              context: context, 
              builder: (context) => AlertDialog(
                title: Text('テスト中断の確認'),
                content: Text('テストを中断してもいいですか'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false), 
                    child: Text('キャンセル')
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true), 
                    child: Text('中断する')
                  )
                ],
              )
            );
            if (isInterruption == false) return;
          }
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home), 
            label: 'HOME'
          ),
          NavigationDestination(
            icon: Icon(Icons.text_snippet), 
            label: 'TEST'
          )
        ]
      ),
      body: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text('単語を入力'),
                  border: OutlineInputBorder()
                ),
                onChanged: (value) {
                  setShowWords();
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: showWords.length,
                  itemBuilder: (context, index) {
                    final word = showWords[index];
                    return WordTile(
                      word: word,
                      showTranslation: _setting['showTranslation'],
                      showCreatedAt: _setting['showCreatedAt'],
                      showLearnedAt: _setting['showLearnedAt'],
                      showLearnedCount: _setting['showLearnedCount'],
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
                        _repo.update(word.copyWith(learnedCount: word.learnedCount + 1, learnedAt: DateTime.now()));
                        getAllWords();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Testpage(
          words: words,
          onPhaseChanged: (phase) {
            testPagePhase = phase;
          },
        ),
      ][currentPageIndex],
    );
  }
}