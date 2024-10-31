import 'package:flutter/material.dart';
import 'package:project_flutter/admin/CauHoi/CauHoi_Service.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';

import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/model/topic.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;
  final Function(Question) onSave;
  final List<Topic> topics;

  EditQuestionScreen({
    required this.question,
    required this.onSave,
    required this.topics,
  });

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController titleController;
  int? chuDeId;
  List<Topic> chuDeList = [];
  final QuestionService _questionService = QuestionService();
  final TopicService _topicService = TopicService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.question.NoiDung_CauHoi);
    chuDeId = widget.question.ChuDe_ID;
    loadTopics();
  }

  Future<void> loadTopics() async {
    try {
      chuDeList = await _topicService.loadTopics();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải chủ đề: $e')));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Chỉnh sửa Câu hỏi', style: TextStyle(fontSize: 22, color: Colors.white)),
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
                    // Tiêu đề câu hỏi
                    TextFormField(
                      controller: titleController,
                      decoration: _inputDecoration('Tên Câu hỏi', Icons.question_answer),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),

                    // Dropdown chọn Đề tài
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
                          child: Text(topic.TenChuDe, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Vui lòng chọn chủ đề';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Nút "Lưu" để lưu câu hỏi đã chỉnh sửa
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty && chuDeId != null) {
                          Question updatedQuestion = Question(
                            CauHoi_ID: widget.question.CauHoi_ID,
                            ChuDe_ID: chuDeId!,
                            NoiDung_CauHoi: titleController.text,
                            NgayTao: widget.question.NgayTao,
                            TrangThai: widget.question.TrangThai,
                          );

                          await _questionService.updateQuestion(updatedQuestion);
                          widget.onSave(updatedQuestion);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Câu hỏi đã được chỉnh sửa')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng nhập đủ thông tin')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnColor,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Lưu',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
