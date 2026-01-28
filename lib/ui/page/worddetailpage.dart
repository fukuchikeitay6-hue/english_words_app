import 'package:flutter/material.dart';
import '../../model/word.dart';
import '../../repository/word_repository.dart';

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
        backgroundColor: Colors.white,
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
            SizedBox(height: 8,),
            Row(
              spacing: 20.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('追加日: ${widget.word.createdAt.year}/${widget.word.createdAt.month}/${widget.word.createdAt.day}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('学習日: ${widget.word.learnedAt.year}/${widget.word.learnedAt.month}/${widget.word.learnedAt.day}', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
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