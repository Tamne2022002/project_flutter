// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe.dart';
import 'package:project_flutter/layout/button_game.dart';
import 'package:project_flutter/layout/playgame/quizz_screen.dart';
import 'package:project_flutter/layout/practice/practice_Service.dart';
import 'package:project_flutter/layout/practice/topicset_screen.dart';
import 'package:project_flutter/model/topic.dart';
import 'dart:math' as math;

import '../../color/Color.dart';

class PracticeScreen extends StatefulWidget {
  final int idUser; 
  PracticeScreen({Key? key, required this.idUser}) : super(key: key);
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Future<List<Topic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = PracticeService().loadTopics();
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
        title: Text('LUYỆN TẬP', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Topic>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading topics"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No topics available"));
          }

          List<Topic> topics = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              Topic topic = topics[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicSetScreen(
                          chuDeId: topic.ChuDe_ID, tenChuDe: topic.TenChuDe, idUser: widget.idUser),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFBCA6DF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Expanded(
                          flex: 1,
                          child: Text(
                            'Chủ đề:',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            topic.TenChuDe,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
              );
            },
          );
        },
      ),
    );
  }
}
