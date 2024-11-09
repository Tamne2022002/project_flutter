import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';

import 'package:intl/intl.dart';

class ListHistoryMatch extends StatefulWidget {
  const ListHistoryMatch({super.key});

  @override
  State<ListHistoryMatch> createState() => _ListHistoryMatchState();
}

class _ListHistoryMatchState extends State<ListHistoryMatch> {
  final List _macthes = [
    {
      'id': 1,
      'topic': 'Toán học',
      'user1': 'Người chơi 1',
      'user2': 'Người chơi 2',
      'score1': 100,
      'score2': 40,
      'time': DateFormat('dd/MM/yyyy - hh:mm:ss').format(DateTime.now()),
    },
    {
      'id': 2,
      'topic': 'Vật lý',
      'user1': 'Người chơi 1',
      'user2': 'Người chơi 2',
      'score1': 40,
      'score2': 50,
      'time': DateFormat('dd/MM/yyyy - hh:mm:ss').format(DateTime.now()),
    },
    {
      'id': 3,
      'topic': 'Văn học',
      'user1': 'Người chơi 1',
      'user2': 'Người chơi 2',
      'score1': 80,
      'score2': 60,
      'time': DateFormat('dd/MM/yyyy - hh:mm:ss').format(DateTime.now()),
    },
    {
      'id': 4,
      'topic': 'Khoa học',
      'user1': 'Người chơi 1',
      'user2': 'Người chơi 2',
      'score1': 30,
      'score2': 50,
      'time': DateFormat('dd/MM/yyyy - hh:mm:ss').format(DateTime.now()),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.btnColor,
        title: Text(
          "Lịch sử thi đấu".toUpperCase(),
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: _macthes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                    padding: EdgeInsets.all(11.0),
                    decoration: BoxDecoration(
                        color: AppColors.btnColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3FEAEAEA),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ]),
                    child: ListTile(
                      title: Column(
                        children: [
                          Text("Chủ đề: ${_macthes[index]['topic']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                          )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Ngày thi đấu: ${_macthes[index]['time']}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _macthes[index]['score1'] >
                                              _macthes[index]['score2']
                                          ? Color(0xff00e445)
                                          : Color(0xffF00000)),
                                  child: Text(
                                    "${_macthes[index]['score1']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 32),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Tên: ${_macthes[index]['user1']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text("VS",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff),
                                )),
                            Column(
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _macthes[index]['score1'] <
                                              _macthes[index]['score2']
                                          ? Color(0xff00e445)
                                          : Color(0xfff00000)),
                                  child: Text(
                                    "${_macthes[index]['score2']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 32),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Tên: ${_macthes[index]['user2']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ]),
                    )),
              );
            }),
      ),
    );
  }
}
