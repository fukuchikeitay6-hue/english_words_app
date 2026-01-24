import 'package:flutter/material.dart';
import 'package:sql2/model/word.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sql2/repository/word_repository.dart';

class WordTile extends StatefulWidget {
  final Word word;
  final VoidCallback onTap;

  const WordTile({
    super.key, 
    required this.word,
    required this.onTap,
  });

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(8.0))),
        onTap: widget.onTap,
        title: Text(
          widget.word.word,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff0f0f0f)
          ),
        ),
        subtitle: widget.word.translation.isEmpty
          ? null
          : Text(
          widget.word.translation,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff5f5f5f)
          ),
        ),
        trailing: widget.word.id == null  // 追加ボタン用
          ? null 
          : Text(
          '${widget.word.learnedCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class WordDetailPage extends StatefulWidget {
  final Word word;
  final WordRepository repo;

  const WordDetailPage({
    super.key, 
    required this.word, 
    required this.repo
  });

  @override
  State<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  final TextEditingController _controller = TextEditingController();
  bool isEditing = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.word.word,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100
                    ),
                    child: isEditing 
                      ? TextField(
                        autofocus: true,
                        controller: TextEditingController(text: widget.word.translation),
                        onSubmitted: (value) {
                          widget.word.translation = value;
                          setState(() {
                            isEditing = false;
                          });
                        },
                      )
                      :  widget.word.translation.isEmpty 
                      ? Text(
                        '訳が設定されていません',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor
                        ),
                      )
                      : Text(
                        widget.word.translation,
                      ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  icon: Icon(Icons.edit_note)
                )
              ],
            ),
            SizedBox(height: 16.0,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100
              ),
              child: Text(
                '例文を表示予定',
                style: TextStyle(
                  color: Theme.of(context).disabledColor
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('完了')
                ),
                SizedBox(width: 20,),
                // 削除ボタン
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red
                  ),
                  onPressed: () async {
                    final bool? deleteConfirmed = await showDialog<bool>(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: const Text('削除の確認'),
                        content: Text('「${widget.word.word}」を削除してもよろしいですか'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false), 
                            child: const Text('キャンセル')
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true), 
                            child: Text('削除', style: TextStyle(color: Colors.red),)
                          )
                        ],
                      )
                    );
                    if (deleteConfirmed == true) {
                      await widget.repo.removeWord(widget.word);
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    }
                  }, 
                  child: Text('削除')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewWordPage extends StatefulWidget {
  final Word word;

  const NewWordPage({super.key, required this.word});

  @override
  State<NewWordPage> createState() => _NewWordPageState();
}

class _NewWordPageState extends State<NewWordPage> {
  final TextEditingController translationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    translationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.word.word,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100
              ),
              child: TextField(
                controller: translationController,
              ),
            ),
            SizedBox(height: 16.0,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100
              ),
              child: Text('例文入力'),
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {}, 
                  child: Text('保存')
                ),
                SizedBox(width: 20.0,),
                ElevatedButton(
                  onPressed: () {}, 
                  child: Text('キャンセル')
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'sample', group: 'group')
Widget preview() {
  return NewWordPage(word: Word('test'));
}
