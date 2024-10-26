import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/layout/button_game.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C144E),
      appBar: AppBar(
        backgroundColor: Color(0xFF927DBA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('LUYỆN TẬP', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(25.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: CustomButton(
              icon: Icons.book,
              text: 'Chủ đề Toán',
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
