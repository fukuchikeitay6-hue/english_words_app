import 'package:flutter/material.dart';
import '../../model/word.dart';

class WordTestBox extends StatefulWidget {
  final Word word;
  final Function(bool remembered) onAnswered;

  const WordTestBox({
    super.key, 
    required this.word, 
    required this.onAnswered
  });

  @override
  State<WordTestBox> createState() => _WordTestBoxState();
}

class _WordTestBoxState extends State<WordTestBox> {
  bool isTranslationShowed = false;  // 訳の表示, 非表示を制御

  double _offsetX = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _offsetX += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offsetX > 100 || details.primaryVelocity! > 500) {
          widget.onAnswered(true);
        } else if (_offsetX < -100 || details.primaryVelocity! < -500) {
          widget.onAnswered(false);
        }

        // ドラッグ完了時の挙動
        setState(() {
          _offsetX = 0;
        });
      },
      child: Transform.translate(
        offset: Offset(_offsetX, 0),
        child: Transform.rotate(
          angle: _offsetX / 1000,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            margin: EdgeInsets.all(8.0),
            elevation: 5,
            child: Column(
              children: [
                
                // word
                Column(
                  children: [
                    Center(
                      heightFactor: 1.8,
                      child: Text(
                        widget.word.word,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('追加日: ${widget.word.createdAt.year}/${widget.word.createdAt.month}/${widget.word.createdAt.day}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text('学習日: ${widget.word.learnedAt.year}/${widget.word.learnedAt.month}/${widget.word.learnedAt.day}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600),),
                      ],
                    )
                  ],
                ),
          
                // translation
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      isTranslationShowed = !isTranslationShowed;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    color: isTranslationShowed 
                    ? Colors.grey.shade100
                    : Colors.grey.shade300,
                    child: isTranslationShowed 
                      ? Center(
                        heightFactor: 2.0,
                        child: Text(
                          widget.word.translation,
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.grey.shade900
                          ),
                        )
                      )
                      : Center(
                        heightFactor: 4,
                        child: Text(
                          'ダブルタップで訳を表示',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700
                          ),
                        ),
                      )
                  ),
                ),
          
                // example
                Container(
                  width: double.infinity,
                  color: const Color.from(alpha: 0.5, red: 0.945, green: 0.973, blue: 0.914),
                  child: Center(
                    heightFactor: 2.0,
                    child: Text(
                      'example',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}