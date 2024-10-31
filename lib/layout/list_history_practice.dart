import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/detail_history_practice.dart';
import 'package:intl/intl.dart';

class ListHistoryExample extends StatefulWidget {
  const ListHistoryExample({super.key});

  @override
  State<ListHistoryExample> createState() => _ListHistoryExampleState();
}

class _ListHistoryExampleState extends State<ListHistoryExample> {
  // final List<DSLSLuyentap> _macthes = [];

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
              itemCount: 10,
              itemBuilder: (context, index) {
                final score = (index + 1) * 10;
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailHistoryExample()));
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5.0,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20),
                        ),
                        shadowColor: Color(0x3FEAEAEA),
                        backgroundColor: AppColors.btnColor,
                      ),
                      child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 11.0),
                          // decoration: BoxDecoration(
                          //     color: AppColors.btnColor,
                          //     borderRadius: BorderRadius.circular(20),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Color(0x3FEAEAEA),
                          //         blurRadius: 4,
                          //         offset: Offset(0, 4),
                          //         spreadRadius: 0,
                          //       )
                          //     ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Chủ đề: Chủ đề ${index + 1}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Chơi vào lúc: ${DateFormat('hh:mm:ss').format(DateTime.now())}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Ngày chơi: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
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
                                      score.toString(),
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
              },
            )));
  }
}
