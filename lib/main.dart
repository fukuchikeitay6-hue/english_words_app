import 'package:flutter/material.dart';
import 'ui/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sql practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey)
      ),
      home: Homepage(),
    );
  }
}