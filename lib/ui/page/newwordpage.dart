import 'package:flutter/material.dart';
import '../../model/word.dart';

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
                autofocus: true,
                controller: translationController,
                decoration: InputDecoration(
                  label: Text('訳を入力')
                ),
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
                  onPressed: () {
                    final translation = translationController.text;
                    widget.word.translation = translation;
                    Navigator.pop(context, widget.word);
                  }, 
                  child: Text('保存')
                ),
                SizedBox(width: 20.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  }, 
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