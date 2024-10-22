import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/question.dart';


import 'Them_CauHoi.dart';
import 'Sua_CauHoi.dart';


class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<Question> questions = [];
  List<String> topics = ['Đề tài 1', 'Đề tài 2', 'Đề tài 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text(
          "Danh sách Câu hỏi",
          style: TextStyle(fontSize: 22,color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (var question in questions) _buildListItem(context, question),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  // Hiển thị câu hỏi trong danh sách
  Widget _buildListItem(BuildContext context, Question question) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.btnColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Đề tài: ${question.topic}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Số lượng đáp án: ${question.answers.length}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editItem(context, question),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteItem(context, question),
            ),
          ],
        ),
      ),
    );
  }

  // Nút thêm câu hỏi
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addItem(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Thêm Câu hỏi",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Chỉnh sửa câu hỏi
  void _editItem(BuildContext context, Question question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuestionScreen(
          question: question,
          topics: topics,
          onSave: (updatedQuestion) {
            setState(() {
              question.title = updatedQuestion.title;
              question.topic = updatedQuestion.topic;
              question.answers = updatedQuestion.answers;
              question.correctAnswerIndex = updatedQuestion.correctAnswerIndex;
            });
          },
        ),
      ),
    );
  }

  // Xóa câu hỏi
  void _deleteItem(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa ${question.title}?'),
          content: Text('Bạn có chắc chắn muốn xóa Câu hỏi này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy', style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  questions.remove(question);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa ${question.title}')),
                );
              },
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  // Thêm câu hỏi mới
  void _addItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionScreen(
          topics: topics,
          onSave: (newQuestion) {
            setState(() {
              questions.add(newQuestion);
            });
          },
        ),
      ),
    );
  }
}
