import 'package:flutter/material.dart';
import 'cross_word_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '권프로와 함께하는 자바 야너두',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CrosswordPage(),
    );
  }
}