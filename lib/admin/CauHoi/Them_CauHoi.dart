import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/model/topic.dart';

class AddQuestionScreen extends StatefulWidget {
  final List<Topic> topics;
  final Function(Question) onSave;

  AddQuestionScreen({required this.topics, required this.onSave});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final titleController = TextEditingController();
  String selectedTopic = 'Đề tài 1';

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
        title: Text('Thêm Câu hỏi',
            style: TextStyle(fontSize: 22, color: Colors.white)),
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
              _buildTextFormField(
                  titleController, 'Tên Câu hỏi', Icons.question_answer),

              SizedBox(height: 16),

              // Dropdown chọn Đề tài
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.btnColor,
                value: selectedTopic,
                onChanged: (newTopic) =>
                    setState(() => selectedTopic = newTopic!),
                items: widget.topics
                    .map((topic) => DropdownMenuItem<String>(
                          value: topic.ChuDe_ID.toString(),
                          child: Text(topic.TenChuDe,
                              style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                decoration: _inputDecoration('Chọn Đề tài', Icons.category),
              ),
              SizedBox(height: 16),

              // Nút thêm câu hỏi
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    // Tạo một ID cho câu hỏi mới (có thể tự động hoặc khác)
                    int newQuestionId = 0; // Hoặc một giá trị hợp lệ khác

                    // Khởi tạo một Question mới
                    Question newQuestion = Question(
                      CauHoi_ID: newQuestionId, // Cung cấp ID câu hỏi
                      NoiDung_CauHoi: titleController.text, // Nội dung câu hỏi
                      ChuDe_ID:
                          int.parse(selectedTopic), // Chuyển đổi chủ đề về int
                      createdDate: Timestamp.now(), // Ngày tạo câu hỏi
                      TrangThai: 1, // Trạng thái câu hỏi
      
                    );

                    widget.onSave(newQuestion);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Câu hỏi đã được thêm')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng nhập đủ thông tin')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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
