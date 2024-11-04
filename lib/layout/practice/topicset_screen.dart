import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/playgame/quizz_screen.dart';
import 'package:project_flutter/layout/practice/topicset_Service.dart';
import 'package:project_flutter/model/bode.dart';

class TopicSetScreen extends StatefulWidget {
  final int chuDeId;
  final String tenChuDe;
  final int idUser; 

  const TopicSetScreen({required this.chuDeId, required this.tenChuDe, required this.idUser});

  @override
  State<TopicSetScreen> createState() => _TopicSetScreenState();
}

class _TopicSetScreenState extends State<TopicSetScreen> {
  late Future<List<BoDe>> _boDeFuture;

  @override
  void initState() {
    super.initState();
    _boDeFuture = BoDeLayoutService().loadBoDe(widget.chuDeId);
  }

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
        title: Text(
          widget.tenChuDe,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BoDe>>(
        future: _boDeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "Hệ thống đang cập nhật",
              style: TextStyle(color: Colors.white),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
              "Đang cập nhật bộ đề",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ));
          }

          List<BoDe> boDeList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: boDeList.length,
            itemBuilder: (context, index) {
              BoDe boDe = boDeList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(boDeId: boDe.boDeId, idUser: widget.idUser),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
                          'Bộ đề:',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${boDe.soLuongCau} câu",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
