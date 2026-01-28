import 'package:flutter/material.dart';
import '../../model/word.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewWordPage extends StatefulWidget {
  final Word word;

  const NewWordPage({super.key, required this.word});

  @override
  State<NewWordPage> createState() => _NewWordPageState();
}

class _NewWordPageState extends State<NewWordPage> {
  final TextEditingController translationController = TextEditingController();
  late Future<String> _translateFuture;

  Future<String> translate() async {
    final uri = Uri.http(
      'deepl-api-5snb.onrender.com', 
      '/translate/', 
      {'word': widget.word.word}
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['translation'];
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }

  void setTranslate() async {
    final String translation = await translate();
    translationController.text = translation;
  }

  @override
  void dispose() {
    translationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _translateFuture = translate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _translateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          translationController.text = '';
        }
        translationController.text = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              widget.word.word,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: TextField(
                    autofocus: true,
                    controller: translationController,
                    decoration: InputDecoration(label: Text('訳を入力')),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: Colors.grey.shade100),
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
                      child: Text('保存'),
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text('キャンセル'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
