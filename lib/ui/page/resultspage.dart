import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sql2/model/word.dart';
import 'package:sql2/ui/components/wordtile.dart';
import 'package:sql2/ui/page/testpage.dart';

class ResultsPage extends StatelessWidget {
  final List<TestResult> results;

  final Function(List<Word> words) onReview;
  final VoidCallback onRetry;

  const ResultsPage({super.key, required this.results, required this.onReview, required this.onRetry});

  int get correctNumber => results.where((r) => r.remembered).length;
  int get incorrectNumber => results.where((r) => !r.remembered).length;
  double get accuracyRate => results.isEmpty ? 0 : correctNumber / results.length * 100;
  List<Word> get incorrectWords => results.where((r) => !r.remembered).map((r) => r.word).toList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Text('Result', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                Text('Score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text('正答数: $correctNumber/${results.length}', style: TextStyle(fontSize: 16),),
                    Text('正答率: ${accuracyRate.round().toString()}%', style: TextStyle(fontSize: 16),)
                  ],
                ),
              ],
            ),
            Text('間違えた単語', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
            Expanded(
              child: ListView.builder(
                itemCount: incorrectWords.length,
                itemBuilder:(context, index) {
                  return WordTile(
                    word: incorrectWords[index],
                    onTap: (){}
                  );
                },
              ),
            ),
            Row(
              spacing: 16.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: incorrectWords.isEmpty ? null : () {
                    onReview(incorrectWords);
                  }, 
                  child: Text('復習テスト')
                ),
                ElevatedButton(
                  onPressed: onRetry, 
                  child: Text('もう一度')
                )
              ],
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}