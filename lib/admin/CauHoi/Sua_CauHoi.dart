import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/question.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;
  final List<String> topics;
  final Function(Question) onSave;

  EditQuestionScreen({required this.question, required this.topics, required this.onSave});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController titleController;
  late List<String> answers;
  late int correctAnswerIndex;
  late String selectedTopic;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.question.title);
    answers = List.from(widget.question.answers);
    correctAnswerIndex = widget.question.correctAnswerIndex;
    selectedTopic = widget.question.topic;
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

  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      style: TextStyle(color: Colors.white),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề câu hỏi
              _buildTextFormField(titleController, 'Tên Câu hỏi', Icons.question_answer),

              SizedBox(height: 16),

              // Dropdown chọn Đề tài
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.btnColor,
                value: selectedTopic,
                onChanged: (newTopic) {
                  setState(() {
                    selectedTopic = newTopic!;
                  });
                },
                items: widget.topics
                    .map((topic) => DropdownMenuItem<String>(
                          value: topic,
                          child: Text(topic, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                decoration: _inputDecoration('Chọn Đề tài', Icons.category),
              ),
              SizedBox(height: 16),

              // Danh sách đáp án
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: answers
                    .map((answer) => ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          title: Text(
                            answer,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          leading: Radio<int>(
                            value: answers.indexOf(answer),
                            groupValue: correctAnswerIndex,
                            onChanged: (int? value) {
                              setState(() {
                                correctAnswerIndex = value!;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),

              // Nút "Lưu" để lưu câu hỏi đã chỉnh sửa
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && answers.isNotEmpty) {
                    widget.onSave(Question(
                      title: titleController.text,
                      topic: selectedTopic,
                      answers: answers,
                      correctAnswerIndex: correctAnswerIndex,
                    ));
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
