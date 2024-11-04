import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';

class DetailPracticeHistoryScreen extends StatefulWidget {
  const DetailPracticeHistoryScreen({super.key});

  @override
  State<DetailPracticeHistoryScreen> createState() => _DetailPracticeHistoryScreenState();
}

class _DetailPracticeHistoryScreenState extends State<DetailPracticeHistoryScreen> {
  List data = [
    {
      'id': 1,
      'question': 'Câu hỏi 1',
      'answer': 'Đáp án 1',
      'time': 8,
      'score': 10,
    },
    {
      'id': 2,
      'question': 'Câu hỏi 2',
      'answer': 'Đáp án 2',
      'time': 5,
      'score': 0,
    },
    {
      'id': 3,
      'question': 'Câu hỏi 3',
      'answer': 'Đáp án 3',
      'time': 10,
      'score': 10,
    },
    {
      'id': 4,
      'question': 'Câu hỏi 4',
      'answer': 'Đáp án 4',
      'time': 7,
      'score': 10,
    },
    {
      'id': 5,
      'question': 'Câu hỏi 5',
      'answer': 'Đáp án 5',
      'time': 5,
      'score': 10,
    },
    {
      'id': 6,
      'question': 'Câu hỏi 6',
      'answer': 'Đáp án 6',
      'time': 1,
      'score': 10,
    },{
      'id': 7,
      'question': 'Câu hỏi 7',
      'answer': 'Đáp án 7',
      'time': 6,
      'score': 10,
    },
    {
      'id': 8,
      'question': 'Câu hỏi 8',
      'answer': 'Đáp án 8',
      'time': 3,
      'score': 0,
    },
    {
      'id': 9,
      'question': 'Câu hỏi 9',
      'answer': 'Đáp án 9',
      'time': 4,
      'score': 10,
    },
    {
      'id': 10,
      'question': 'Câu hỏi 10',
      'answer': 'Đáp án 10',
      'time': 2,
      'score': 10,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
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
                child: Text(
                  'Chủ đề: Toán học',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
                      '8\nCâu đúng',
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
                      '2\nCâu sai',
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
              for (var i = 0; i < data.length; i++)
                Card(
                  margin: EdgeInsets.symmetric(vertical: 12.5),
                  
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.btnColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        top: BorderSide(
                          color: data[i]['score'] == 0 ? Color(0xFFF00000) : Color(0xFF00E445),
                          width: 8.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${i + 1}: ${data[i]['question']}',
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
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Colors.white.withOpacity(0.5),
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
                            '${data[i]['answer']}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.maxFinite,
                            height: 1,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        'Thời gian: ${data[i]['time']}s',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
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
                                        'Điểm: ${data[i]['score']} exp',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
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
            ],
          ),
        ),
      ),
    );
  }
}
