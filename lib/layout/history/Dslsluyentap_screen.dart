import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/history/Chitietlsluyentap_screen.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/model/chitiettraloi.dart';
import 'package:project_flutter/model/choigame.dart';
import 'package:project_flutter/model/topic.dart';
import 'Service.dart';

class PracticeHistoryScreen extends StatefulWidget {
  const PracticeHistoryScreen({super.key});

  @override
  State<PracticeHistoryScreen> createState() => _PracticeHistoryScreenState();
}

class _PracticeHistoryScreenState extends State<PracticeHistoryScreen> {
  final HistoryPracticeService _historyPracticeService =
      HistoryPracticeService();
  List<ChoiGame> luyenTapList = [];
  List<Topic> chuDeList = []; 
  @override
  void initState() {
    super.initState();
    getLuyenTapList();
  }

  Future<void> getLuyenTapList() async {
    try {
      final loadedPractices =
          await _historyPracticeService.getLuyenTapList();
      setState(() {
        luyenTapList = loadedPractices;
      });
    } catch (e) {
      print("Error loading b: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tại danh sách lịch sử luyện tập')),
      );
    }
  }

  // Lấy tên chủ đề từ ID
  String _getTopicName(int? chuDeId) {
    final topic = chuDeList.firstWhere((t) => t.ChuDe_ID == chuDeId, orElse: () => Topic(ChuDe_ID: 0, TenChuDe: 'Không có chủ đề',SLCauHoi: 0));
    return topic.TenChuDe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
          title: Text(
            "Lịch sử luyện tập".toUpperCase(),
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          backgroundColor: AppColors.btnColor,
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: luyenTapList.length,
              itemBuilder: (context, index) {
                if (luyenTapList.length > 0) {
                  var data = luyenTapList[index];
                  
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailPracticeHistoryScreen()));
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5.0,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Color(0x3FEAEAEA),
                          backgroundColor: AppColors.btnColor,
                        ),
                        child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 11.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Chủ đề: ${_getTopicName(data.chuDe_ID)}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Chơi vào lúc: ${DateFormat('hh:mm:ss').format(data.create_at!)}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Ngày chơi: ${new DateFormat('dd/MM/yyyy').format(data.create_at!)}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFDDCFF2),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${data.tongDiem}",
                                        style: TextStyle(
                                          color: Color(0xff341c4d),
                                          fontSize: 30,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )))
                              ],
                            )),
                      ));
                } else {
                  return Text("Không có dữ liệu");
                }
              },
            )));
  }
}
