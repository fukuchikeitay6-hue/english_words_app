import 'package:flutter/material.dart';
import 'package:sql2/model/word.dart';
import '../components/wordtesttile.dart';
import './resultspage.dart';

enum TestPhase {
  setting,
  running,
  finished
}

class Testpage extends StatefulWidget {
  final List<Word> words;

  final void Function(TestPhase phase)? onPhaseChanged;

  const Testpage({super.key, required this.words, required this.onPhaseChanged});

  @override
  State<Testpage> createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {
  late List<Word> testWords;

  TestPhase phase = TestPhase.setting;

  int currentIndex = 0;
  List<TestResult> results = [];

  Word get currentWord => testWords[currentIndex];

  void setPhase(TestPhase newPhase) {
    setState(() {
      phase = newPhase;
    });
    widget.onPhaseChanged?.call(newPhase);
  }

  void startTest() {
    setPhase(TestPhase.running);
  }

  void onRemembered(bool remembered) {
    setState(() {
      results.add(
        TestResult(
          word: currentWord, 
          remembered: remembered
        )
      );
    });

    if (currentIndex < testWords.length -1) {
      setState(() {
        currentIndex++;
      });
    } else {
      setPhase(TestPhase.finished);
    }
  }

  @override
  void initState() {
    super.initState();
    testWords = List.from(widget.words);
  }

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case TestPhase.running:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Spacer(),
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
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.red, backgroundColor: Colors.red.shade50),
                onPressed: () async {
                  final bool? isInterruption = await showDialog<bool>(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: Text('テストを中断'),
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
                  if (isInterruption == true) {
                    setPhase(TestPhase.setting);
                  }
                }, 
                child: Text('中断する')
              )
            ],
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
        return ResultsPage(
          results: results,
          onReview: (words) {
            setState(() {
              testWords = List.from(words);
              currentIndex = 0;
              results.clear();
            });
            setPhase(TestPhase.running);
          },
          onRetry: () {
            setState(() {
              currentIndex = 0;
              results.clear();
            });
            setPhase(TestPhase.running);
          },
        );
    }
  }
}