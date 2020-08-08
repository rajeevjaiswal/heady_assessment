import 'package:flutter/material.dart';
import 'package:heady/constants/app_theme.dart';
import 'package:heady/ui/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heady',
      theme: themeData,
      home: MyHomePage(),
    );
  }
}
