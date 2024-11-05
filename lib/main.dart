import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/firebase_options.dart';
import 'package:project_flutter/layout/home_screen.dart';
import 'package:project_flutter/layout/practice/practice_screen.dart';
import 'package:project_flutter/authen/login_screen.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

// void main() {
//   runApp( MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
