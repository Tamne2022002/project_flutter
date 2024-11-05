import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/compete/chitiettraloi_Service.dart';
import 'package:project_flutter/layout/compete/choigame_Service.dart';
import 'package:project_flutter/layout/playgame/answers_Service.dart';
import 'package:project_flutter/layout/playgame/question_Service.dart';
import 'package:project_flutter/model/DapAn.dart';
import 'package:project_flutter/model/chitiettraloi.dart';
import 'package:project_flutter/model/choigame.dart';
import 'package:project_flutter/model/question.dart';

class QuizScreen extends StatefulWidget {
  final int boDeId;
  final int idUser;

  const QuizScreen({Key? key, required this.boDeId, required this.idUser})
      : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionService _questionService = QuestionService();
  final DapAnService _dapanService = DapAnService();
  final ChoiGameService _choiGameService = ChoiGameService();
  final ChiTietTraLoiService _chiTietTraLoiService = ChiTietTraLoiService();

  int _timeRemaining = 10;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool isAnswerSaved = false;
  List<Question> _questions = [];
  Map<int, List<DapAn>> _answersMap = {};
  List<Color> _optionColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];

  @override
  void initState() {
    super.initState();
    loadQuestionsAndAnswers();
    startTimer();
  }

  Future<void> loadQuestionsAndAnswers() async {
    _questions = await _questionService.loadQuestions(widget.boDeId);

    for (var question in _questions) {
      _answersMap[question.CauHoi_ID] =
          await _dapanService.loadAnswers(question.CauHoi_ID);
    }
    setState(() {});
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();
          autoSelectAnswer();
        }
      });
    });
  }

  void restartTimer() {
    if (_timer?.isActive ?? false) _timer!.cancel();
    startTimer();
  }

  void autoSelectAnswer() {
    List<DapAn>? currentAnswers =
        _answersMap[_questions[_currentQuestionIndex].CauHoi_ID];
    if (currentAnswers != null && currentAnswers.isNotEmpty) {
      handleAnswerSelected(currentAnswers[0], 0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
 

  Future<void> _endGame() async {
    int nextId = await _choiGameService.getNextGameId();

    ChoiGame gameResult = ChoiGame(
      id: nextId,
      boDe_ID: widget.boDeId,
      chuDe_ID: _questions.first.ChuDe_ID,
      nguoiDung_ID: widget.idUser,
      theLoai: "luyentap",
      trangThai: 1,
      create_at: DateTime.now(),
      tongDiem: _score,
    );

    await _choiGameService.saveGameResult(gameResult);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> handleAnswerSelected(DapAn answer, int index) async {
    if (!mounted || isAnswerSaved) return;

    setState(() {
      if (answer.DungSai) {
        _optionColors[index] = Colors.green;
        _score += answer.Diem;
      } else {
        _optionColors[index] = Colors.red;
      }
    });
    
    int nextidDetail = await _chiTietTraLoiService.getNextChiTietTraLoiId();
    int thoiGianTraLoi = 10 - _timeRemaining;
    ChiTietTraLoi chiTietTraLoi = ChiTietTraLoi(
      id: nextidDetail,
      gameId: widget.boDeId,
      cauHoiId: _questions[_currentQuestionIndex].CauHoi_ID,
      diem: _score,
      thoiGianTraLoi: thoiGianTraLoi,
      trangThai: answer.DungSai ? 1 : 0,
      createAt: DateTime.now(),
    );

    await _chiTietTraLoiService.saveChiTietTraLoi(chiTietTraLoi);
    isAnswerSaved = true;

    if (_timer?.isActive ?? false) _timer!.cancel(); 

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _optionColors = [ Colors.white, Colors.white, Colors.white, Colors.white];

        // set lại thời gian 
        _timeRemaining = 10;
        isAnswerSaved = false;
        startTimer();

      } else {
        _endGame();
      }
    });
  }

  Future<void> showExitConfirmationDialog() async {
    bool? confirmExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận thoát'),
          content: Text(
              'Bạn có chắc chắn muốn thoát không? Kết quả của bạn sẽ được lưu lại.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true),
              child: Text('Thoát'),
            ),
          ],
        );
      },
    );

    Future<void> _saveCurrentGame() async {
      int nextId = await _choiGameService.getNextGameId();

      ChoiGame gameOutResult = ChoiGame(
        id: nextId,
        boDe_ID: widget.boDeId,
        chuDe_ID: _questions.isNotEmpty ? _questions.first.ChuDe_ID : 0,
        nguoiDung_ID: widget.idUser,
        theLoai: "luyentap",
        trangThai: 1,
        create_at: DateTime.now(),
        tongDiem: _score,
      );

      await _choiGameService.saveGameResult(gameOutResult);
    }

    if (confirmExit == true) {
      await _saveCurrentGame();
      if (mounted) {
        Navigator.pop(context);
      }
    }
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
          onPressed: () async {
            await showExitConfirmationDialog();
          },
        ),
        title: Text('Đang Chơi',
            style: TextStyle(fontSize: 20, color: Colors.white)),
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
              enabled: false,
              controller:
                  TextEditingController(text: currentQuestion.NoiDung_CauHoi),
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
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
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
                        child:
                            Text(answer.ND_DapAn, style: TextStyle(fontSize: 18)),
                      ),
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
