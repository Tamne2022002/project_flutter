import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/button_game.dart';
import 'package:project_flutter/layout/mode_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor, // Dark purple background
      appBar: AppBar(
        backgroundColor: AppColors.btnColor, // Light purple top bar
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text('TRANG CHỦ', style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, size: 120, color: Colors.white),
            const SizedBox(height: 60),
            CustomButton(
              icon: Icons.play_arrow,
              text: 'Tham gia ngay',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ModeScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Start from the right
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
            ),
            CustomButton(
              icon: Icons.people,
              text: 'Danh sách bạn',
              onPressed: () {},
            ),
            CustomButton(
              icon: Icons.person_add,
              text: 'Thêm bạn bè',
              onPressed: () {},
            ),
            CustomButton(
              icon: Icons.history,
              text: 'Lịch sử chơi',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ); 
  }
}