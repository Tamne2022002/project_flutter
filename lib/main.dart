import 'package:flutter/material.dart';
import 'package:project_flutter/layout/home_screen.dart';
import 'package:project_flutter/layout/practice_screen.dart';
import 'package:project_flutter/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
