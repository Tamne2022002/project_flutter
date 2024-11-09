import 'dart:developer';
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/history/Service.dart';
import 'package:project_flutter/model/DapAn.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/chitiettraloi.dart';
import 'package:project_flutter/model/choigame.dart';
import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/model/topic.dart';

class DetailPracticeHistoryScreen extends StatefulWidget {
  final int choiGameInfo;
  final int chuDe_ID;
  final int boDe_ID;
  final int gameId;
  const DetailPracticeHistoryScreen(
      {super.key,
      required this.choiGameInfo,
      required this.chuDe_ID,
      required this.boDe_ID,
      required this.gameId});

  @override
  State<DetailPracticeHistoryScreen> createState() =>
      _DetailPracticeHistoryScreenState();
}

class _DetailPracticeHistoryScreenState
    extends State<DetailPracticeHistoryScreen> {
  late int choiGameInfo;
  late int chuDe_ID;
  late int boDe_ID;
  late int gameId;

  final HistoryPracticeService _historyPracticeService =
      HistoryPracticeService();

  List<Topic> chuDeList = [];
  // List<ChiTietBoDe> listQuestionDetailTask = [];
  List<Question> listQuestionInfo = [];
  List<DapAn> listAnswer = [];
  List<ChiTietTraLoi> listCTTL = [];

  int soCauDung = 0;
  int soCauSai = 0;

  @override
  void initState() {
    super.initState();
    choiGameInfo = widget.choiGameInfo;
    chuDe_ID = widget.chuDe_ID;
    boDe_ID = widget.boDe_ID;
    gameId = widget.gameId;
    OnLoad();
  }

  Future<void> OnLoad() async {
    await getTopicName();
    await getQuestionInfo();
    await getDetailAnswerInfo();
    await getAnswerInfo();

    for (var i = 0; i < listCTTL.length; i++) {
      var diem = _getScoreAnswer(listCTTL[i].cauHoiId);

      if (diem == 10) {
        soCauDung += 1;
      } else if (diem == 0) {
        soCauSai += 1;
      }
    }
  }

  // Lấy danh sách chủ đề
  Future<void> getTopicName() async {
    final loadedTopics = await _historyPracticeService.getChuDeList();
    setState(() {
      chuDeList = loadedTopics;
    });
  }

  //Lấy tên chủ đề
  String _getTopicName(int? chuDeId) {
    final topic = chuDeList.firstWhere((t) => t.ChuDe_ID == chuDeId,
        orElse: () =>
            Topic(ChuDe_ID: 0, TenChuDe: 'Không có chủ đề', SLCauHoi: 0));
    return topic.TenChuDe;
  }

  //Lấy danh sách thông tin của câu hỏi vd: nội dung, trạng thái, ...
  Future<void> getQuestionInfo() async {
    final loadedQuestion = await _historyPracticeService.getCauHoiList();
    setState(() {
      listQuestionInfo = loadedQuestion;
    });
  }

  //Lấy nội dung của câu hỏi
  String _getQuestion(int? cauHoiId) {
    final cauHoi = listQuestionInfo.firstWhere((t) => t.CauHoi_ID == cauHoiId,
        orElse: () => Question(
            CauHoi_ID: 0,
            NoiDung_CauHoi: 'Không có cau hỏi',
            ChuDe_ID: 0,
            TrangThai: 1,
            NgayTao: DateTime.now()));
    return cauHoi.NoiDung_CauHoi;
  }

  Future<void> getAnswerInfo() async {
    final loadedAnswer = await _historyPracticeService.getDapAn();
    setState(() {
      listAnswer = loadedAnswer;
    });
  }

  String _getContentAnswer(int? cauHoiId) {
    final content = listAnswer.firstWhere(
        (t) => t.CauHoi_ID == cauHoiId && t.DungSai == true,
        orElse: () => DapAn(
            CauHoi_ID: 0,
            ND_DapAn: 'Không có đáp án',
            DungSai: false,
            Diem: 0,
            TrangThai: 1));
    return content.ND_DapAn;
  }

  Future<void> getDetailAnswerInfo() async {
    final loadedDetailAnswer =
        await _historyPracticeService.getCTTL(gameId);
    setState(() {
      listCTTL = loadedDetailAnswer;
    });
  }

  int _getScoreAnswer(int? cauHoiId) {
    final score = listCTTL.firstWhere((t) => t.cauHoiId == cauHoiId,
        orElse: () => ChiTietTraLoi(
            id: 0,
            cauHoiId: 0,
            diem: 0,
            createAt: DateTime.now(),
            thoiGianTraLoi: 0,
            trangThai: 1,
            gameId: 0));
    return score.diem;
  }

  int _getTimeAnswer(int? cauHoiId) {
    final score = listCTTL.firstWhere((t) => t.cauHoiId == cauHoiId,
        orElse: () => ChiTietTraLoi(
            id: 0,
            cauHoiId: 0,
            diem: 0,
            createAt: DateTime.now(),
            thoiGianTraLoi: 0,
            trangThai: 1,
            gameId: 0));
    return score.thoiGianTraLoi;
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.btnColor,
        title: Text(
          "Chi tiết lịch sử luyện tập".toUpperCase(),
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 44, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text("Chủ đề: ${_getTopicName(chuDe_ID)}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 180,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Color(0xFF080341),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    image: DecorationImage(
                        image: Image.asset('images/16.png').image,
                        fit: BoxFit.contain,
                        alignment: AlignmentDirectional.centerStart),
                  ),
                  child: Center(
                    child: Text(
                      '${soCauDung}\nCâu đúng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Color(0xFF080341),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    image: DecorationImage(
                        image: Image.asset('images/17.png').image,
                        fit: BoxFit.contain,
                        alignment: AlignmentDirectional.centerStart),
                  ),
                  child: Center(
                    child: Text(
                      '${soCauSai}\nCâu sai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 30),
              ListView.builder(
                itemCount: listCTTL.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: !listCTTL.isNotEmpty
                        ? Container(
                            child: Center(
                            child: Text(
                              "Không có dữ liệu".toUpperCase(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ))
                        : Card(
                            margin: EdgeInsets.symmetric(vertical: 12.5),
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 18),
                              decoration: BoxDecoration(
                                color: AppColors.btnColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border(
                                  top: BorderSide(
                                    color: _getScoreAnswer(
                                                listCTTL[index].cauHoiId) ==
                                            0
                                        ? Color(0xFFF00000)
                                        : Color(0xFF00E445),
                                    width: 8.0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Câu hỏi${index}: ${_getQuestion(listCTTL[index].cauHoiId)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: double.maxFinite,
                                      height: 1,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đáp án chính xác: ${_getContentAnswer(listCTTL[index].cauHoiId)}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: double.maxFinite,
                                      height: 1,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                  'Thời gian: ${_getTimeAnswer(listCTTL[index].cauHoiId)}s',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                  'Điểm: ${_getScoreAnswer(listCTTL[index].cauHoiId)} XP',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
