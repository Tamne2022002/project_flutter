import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/button_game.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _timeRemaining = 60; // Timer starting value
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();
          // Handle timeout (e.g., show alert or move to next question)
        }
      });
    });
  }

  Widget optionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFF1855B4),
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          // Handle answer selection
        },
        child: Text(text, style: TextStyle(fontSize: 18)),
      ),
    );
  }

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
        title: Text('Đang Luyện Tập',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Timer and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 40, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '00:${_timeRemaining.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Question Box
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF927DBA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Câu hỏi 1:',
                style: TextStyle(fontSize: 20, color: Color(0xFF3C144E)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // Answer Options
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    icon: Icons.question_answer,
                    text: 'A',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QuizScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
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
                    icon: Icons.question_answer,
                    text: 'B',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QuizScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
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
                    icon: Icons.question_answer,
                    text: 'C',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QuizScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
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
                    icon: Icons.question_answer,
                    text: 'D',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QuizScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
