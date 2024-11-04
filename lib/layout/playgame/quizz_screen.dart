import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/button_game.dart';
import 'package:project_flutter/layout/playgame/answers_Service.dart';
import 'package:project_flutter/layout/playgame/question_Service.dart';
import 'package:project_flutter/model/DapAn.dart';
import 'package:project_flutter/model/question.dart';

class QuizScreen extends StatefulWidget {
  final int boDeId;
  final int idUser; 

  const QuizScreen({Key? key, required this.boDeId, required this.idUser}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionService _questionService = QuestionService();
  final DapAnService _dapanService = DapAnService();

  int _timeRemaining = 10;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Question> _questions = [];
  Map<int, List<DapAn>> _answersMap = {};
  List<Color> _optionColors = [Colors.white, Colors.white, Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    startTimer();
    loadQuestionsAndAnswers();
  }
 
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();

        List<DapAn>? currentAnswers = _answersMap[_questions[_currentQuestionIndex].CauHoi_ID];
        if (currentAnswers != null && currentAnswers.isNotEmpty) {
          handleAnswerSelected(currentAnswers[0], 0); // Chọn câu trả lời đầu tiên khi hết thời gian
        }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadQuestionsAndAnswers() async {
    // Lấy câu hỏi từ QuestionService
    _questions = await _questionService.loadQuestions(widget.boDeId);

    // Lấy đáp án cho từng câu hỏi từ DapAnService và lưu vào map
    for (var question in _questions) {
      _answersMap[question.CauHoi_ID] = await _dapanService.loadAnswers(question.CauHoi_ID);
    }

    setState(() {}); // Cập nhật lại giao diện khi đã có dữ liệu
  }

  void handleAnswerSelected(DapAn answer, int index) {
    setState(() {
      if (answer.DungSai) {
        _optionColors[index] = Colors.green; // Đáp án đúng
        _score += answer.Diem; // Cộng điểm nếu trả lời đúng
      } else {
        _optionColors[index] = Colors.red; // Đáp án sai
      }
    });

    // Sau 2 giây chuyển sang câu hỏi tiếp theo
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _optionColors = [Colors.white, Colors.white, Colors.white, Colors.white];

          _timeRemaining = 10; // Đặt lại thời gian ban đầu
          startTimer();
        } else {
          // Kết thúc câu hỏi, quay về trang chủ đề
          Navigator.pop(context);
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _answersMap.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.backColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Question currentQuestion = _questions[_currentQuestionIndex];
    List<DapAn> currentAnswers = _answersMap[currentQuestion.CauHoi_ID] ?? [];

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
        title: Text('Đang Chơi - ID: ${widget.idUser}', style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
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
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                'Câu hỏi ${_currentQuestionIndex + 1}:',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
 
            SizedBox(height: 10),
            TextField(
              enabled: false, // Không cho phép chỉnh sửa
              controller: TextEditingController(text: currentQuestion.NoiDung_CauHoi),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.start,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                filled: true,
                fillColor: Color(0xFF927DBA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: currentAnswers.asMap().entries.map((entry) {
                  int index = entry.key;
                  DapAn answer = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _optionColors[index],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => handleAnswerSelected(answer, index),
                      child: Text(answer.ND_DapAn, style: TextStyle(fontSize: 18)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ); 
  }
}
