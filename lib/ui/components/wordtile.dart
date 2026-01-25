import 'package:flutter/material.dart';
import '../../model/word.dart';

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
        leading: widget.word.id == null  // 追加ボタン用
          ? null 
          : Text(
          '${widget.word.learnedCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: widget.word.id == null
        ? null 
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('追加日: ${widget.word.createdAt.year}/${widget.word.createdAt.month}/${widget.word.createdAt.day}', style: TextStyle(fontSize: 10, color: Colors.grey),),
            Text('学習日: ${widget.word.learnedAt.year}/${widget.word.learnedAt.month}/${widget.word.learnedAt.day}', style: TextStyle(fontSize: 10, color: Colors.grey),),
          ],
        ),
      ),
    );
  }
}