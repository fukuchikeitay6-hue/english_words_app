import 'package:flutter/material.dart';
import 'package:sql2/model/word.dart';
import '../repository/word_repository.dart';
import 'package:flutter/widget_previews.dart';

class WordTile extends StatefulWidget {
  final Word word;
  final VoidCallback onDelete;

  const WordTile({
    super.key, 
    required this.word,
    required this.onDelete
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
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => WordDetailPage(word: widget.word))
          );
        },
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
        trailing: IconButton(
          onPressed: () {
            widget.onDelete;
          }, 
          icon: Icon(Icons.delete)
        ),
      ),
    );
  }
}

class WordDetailPage extends StatefulWidget {
  final Word word;

  const WordDetailPage({super.key, required this.word});

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
                  onPressed: () {}, 
                  child: Text('保存')
                ),
                SizedBox(width: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('キャンセル')
                )
              ],
            )],
        ),
      ),
    );
  }
}

@Preview(name: 'sample')
Widget preview() {
  return Text('');
}
