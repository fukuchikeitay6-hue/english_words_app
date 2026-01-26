import 'package:flutter/material.dart';
import 'package:sql2/model/word.dart';
import '../components/wordtesttile.dart';
import '../../model/word.dart';
import './resultspage.dart';

enum TestPhase {
  setting,
  running,
  finished
}

class Testpage extends StatefulWidget {
  final List<Word> words;

  const Testpage({super.key, required this.words});

  @override
  State<Testpage> createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {
  TestPhase phase = TestPhase.setting;

  int currentIndex = 0;
  List<TestResult> results = [];

  Word get currentWord => widget.words[currentIndex];

  void startTest() {
    setState(() {
      phase = TestPhase.running;
    });
  }

  void onRemembered(bool remembered) {
    results.add(
      TestResult(
        word: currentWord, 
        remembered: remembered
      )
    );

    if (currentIndex < widget.words.length -1) {
      setState(() {
        currentIndex++;
      });
    } else {
      setState(() {
        phase = TestPhase.finished;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case TestPhase.running:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                WordTestBox(
                  word: currentWord,
                  onAnswered: (remembered) {
                    onRemembered(remembered);
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_back_ios),
                          Text('覚えてない'),
                        ],
                      ),
                    ),
                    Center(child: Text('swipe', textAlign: TextAlign.center,)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('覚えた'),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );

      case TestPhase.setting:
      return Center(
        child: TextButton(
          onPressed: startTest, 
          child: Text('start')
        ),
      );

      case TestPhase.finished:
        return Text('result');
    }
  }
}