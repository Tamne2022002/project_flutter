import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/quizz_screen.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Phòng chờ', style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.account_circle, size: 80, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Bạn',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  'VS',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Icon(Icons.account_circle, size: 80, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Đối thủ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                  padding: EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
                },
                child: Text(
                  'Chơi',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } 
}