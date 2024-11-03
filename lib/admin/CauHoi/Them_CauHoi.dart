import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/admin/CauHoi/CauHoi_Service.dart';
import 'package:project_flutter/admin/CauHoi/DapAn_Service.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:project_flutter/model/dapan.dart';

class AddQuestionScreen extends StatefulWidget {
  final Question question;
  final List<Topic> topics;
  final Function(Question) onSave;

  AddQuestionScreen({
    required this.topics,
    required this.onSave,
    required this.question,
  });

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  late TextEditingController titleController;
  late TextEditingController answerController;
  List<Topic> chuDeList = [];
  List<Question> cauHoiList = [];
  final QuestionService _questionService = QuestionService();
  final TopicService _topicService = TopicService();
  final DapAnService _dapAnService = DapAnService();
  bool isLoading = true;
  int? chuDeId;
  List<DapAn> answers = []; // Danh sách đáp án
  int? correctAnswerIndex; // Chỉ số đáp án đúng

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.question.NoiDung_CauHoi);
    answerController = TextEditingController();
    chuDeId = widget.question.ChuDe_ID;
    loadTopics();
  }

  Future<void> loadTopics() async {
    try {
      cauHoiList = await _questionService.loadQuestions();
      chuDeList = await _topicService.loadTopics();

      if (!chuDeList.any((topic) => topic.ChuDe_ID == chuDeId)) {
        chuDeId = null;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải chủ đề: $e')));
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  void _addAnswer() {
    if (answerController.text.isNotEmpty) {
      DapAn newAnswer = DapAn(
        CauHoi_ID: widget.question.CauHoi_ID,
        ND_DapAn: answerController.text,
        DungSai: false, // Mặc định là false, sẽ chỉnh sửa sau
        Diem: 0, // Mặc định 0
        TrangThai: 1,
      );

      setState(() {
        answers.add(newAnswer);
        answerController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Thêm Câu hỏi',
            style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                        titleController, 'Tên Câu hỏi', Icons.question_answer),

                    SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      dropdownColor: AppColors.btnColor,
                      value: chuDeId,
                      decoration: _inputDecoration('Chủ đề', Icons.category),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          chuDeId = value;
                        });
                      },
                      items: chuDeList.map((topic) {
                        return DropdownMenuItem<int>(
                          value: topic.ChuDe_ID,
                          child: Text(topic.TenChuDe,
                              style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                              answerController, 'Đáp án', Icons.edit),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnColor,
                          ),
                          child: Text('Thêm',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Hiển thị danh sách các đáp án
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                answers[index].ND_DapAn,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Radio<int>(
                              value: index,
                              groupValue: correctAnswerIndex,
                              onChanged: (value) {
                                setState(() {
                                  correctAnswerIndex = value;
                                  // Cập nhật lại trạng thái đúng/sai cho đáp án
                                  for (int i = 0; i < answers.length; i++) {
                                    answers[i].DungSai = (i != value);
                                    answers[i].Diem = (i == value) ? 10 : 0;
                                  }
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            chuDeId != null) {
                          // Tạo ID cho câu hỏi mới
                          int newCauHoiId =
                              cauHoiList.isNotEmpty ? cauHoiList.length + 1 : 1;

                          // Tạo câu hỏi mới
                          Question newQuestion = Question(
                            CauHoi_ID: newCauHoiId,
                            NoiDung_CauHoi: titleController.text,
                            ChuDe_ID: chuDeId!,
                            NgayTao: DateTime.now(),
                            TrangThai: 1,
                          );

                          // Thêm câu hỏi vào cơ sở dữ liệu
                          _questionService
                              .addQuestion(newQuestion)
                              .then((_) async {
                            // Thêm các đáp án với CauHoi_ID là newCauHoiId
                            for (var answer in answers) {
                              answer.CauHoi_ID =
                                  newCauHoiId; // Cập nhật CauHoi_ID cho đáp án
                              await _dapAnService.addAnswer(answer);
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Câu hỏi và đáp án đã được thêm')));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Có lỗi xảy ra: $error')));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Vui lòng nhập đủ thông tin')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('Thêm Câu hỏi',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      style: TextStyle(color: Colors.white),
    );
  }
}
