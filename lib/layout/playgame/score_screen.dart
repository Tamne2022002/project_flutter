import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/home_screen.dart';
import 'package:project_flutter/layout/practice/practice_screen.dart'; 

class ScoreScreen extends StatelessWidget {
  final int score;
  final int idUser;

  const ScoreScreen({Key? key, required this.score, required this.idUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        automaticallyImplyLeading: false, 
        title: Text(
          'Tổng kết',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tổng Điểm: $score',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(  
                    builder: (context) => HomeScreen(
                      idUser: idUser,
                    ),
                  ),
                  (route) => false, 
                );
              },
              child: const Text(
                'Quay Lại',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
