import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/admin/CauHoi/CauHoi_Service.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/model/topic.dart';
import 'Them_CauHoi.dart';
import 'Sua_CauHoi.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<Question> questions = [];
  List<Question> filteredQuestions = [];
  List<Topic> chuDeList = []; 
  final QuestionService _questionService = QuestionService();
  final TopicService _topicService = TopicService();
  bool isLoading = true;
  int? selectedTopicId;

  @override
  void initState() {
    super.initState();
    loadTopics(); // Tải danh sách chủ đề
    _loadQuestions(); // Tải danh sách câu hỏi
  }

  // Tải câu hỏi từ Firestore
  Future<void> _loadQuestions() async {
    try {
      questions = await _questionService.loadQuestions();
      _filterQuestions(); // Lọc câu hỏi ban đầu
      setState(() {}); // Cập nhật giao diện
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải câu hỏi: $e')));
    }
  }

  // Tải danh sách chủ đề từ Firestore
  Future<void> loadTopics() async {
    try {
      chuDeList = await _topicService.loadTopics();
      setState(() {
        isLoading = false; // Đã tải xong danh sách chủ đề
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải chủ đề: $e')));
    }
  }

  // Lọc câu hỏi theo chủ đề đã chọn
  void _filterQuestions() {
    if (selectedTopicId == null) {
      filteredQuestions = questions; // Hiển thị tất cả câu hỏi nếu không có chủ đề nào được chọn
    } else {
      filteredQuestions = questions.where((q) => q.ChuDe_ID == selectedTopicId).toList();
    }
  }

  // Lấy tên chủ đề từ ID
  String _getTopicName(int? chuDeId) {
    final topic = chuDeList.firstWhere((t) => t.ChuDe_ID == chuDeId, orElse: () => Topic(ChuDe_ID: 0, TenChuDe: 'Không có chủ đề',SLCauHoi: 0));
    return topic.TenChuDe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text(
          "Danh sách Câu hỏi",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown(), // Thêm dropdown menu cho chủ đề
            Expanded(
              child: ListView(
                children: [
                  for (var question in filteredQuestions) _buildListItem(context, question),
                  _buildAddButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xây dựng dropdown menu cho chủ đề
  Widget _buildDropdown() {
    return DropdownButton<int>(
      value: selectedTopicId,
      hint: Text("Chọn Chủ đề", style: TextStyle(color: Colors.white)),
      dropdownColor: AppColors.btnColor,
      isExpanded: true,
      onChanged: (int? newValue) {
        setState(() {
          selectedTopicId = newValue; // Cập nhật chủ đề đã chọn
          _filterQuestions(); // Lọc câu hỏi theo chủ đề đã chọn
        });
      },
      items: chuDeList.map<DropdownMenuItem<int>>((Topic topic) {
        return DropdownMenuItem<int>(
          value: topic.ChuDe_ID,
          child: Text(
            topic.TenChuDe,
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
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
              question.NoiDung_CauHoi,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Chủ đề: ${_getTopicName(question.ChuDe_ID)}', // Hiển thị tên chủ đề
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Ngày tạo: ${question.NgayTao}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Trạng thái: ${question.TrangThai}',
              style: TextStyle(
                fontSize: 14,
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
          topics: chuDeList,
          onSave: (updatedQuestion) {
            setState(() {
              question.NoiDung_CauHoi = updatedQuestion.NoiDung_CauHoi;
              question.ChuDe_ID = updatedQuestion.ChuDe_ID;
              _loadQuestions(); // Làm mới danh sách câu hỏi
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
          title: Text('Xóa ${question.NoiDung_CauHoi}?'),
          content: Text('Bạn có chắc chắn muốn xóa Câu hỏi này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy', style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _questionService.deleteQuestion(question.CauHoi_ID);
                  setState(() {
                    questions.remove(question);
                    _filterQuestions(); // Làm mới danh sách câu hỏi sau khi xóa
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa ${question.NoiDung_CauHoi}')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                } finally {
                  Navigator.pop(context);
                }
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
    Question newQuestion = Question(
      CauHoi_ID: 0, 
      NoiDung_CauHoi: '', 
      ChuDe_ID: 0, 
      NgayTao: DateTime.now(), 
      TrangThai: 1,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionScreen(
          topics: chuDeList,
          onSave: (addedQuestion) {
            setState(() {
              questions.add(addedQuestion);
              _filterQuestions(); // Lọc lại danh sách câu hỏi
            });
          },
          question: newQuestion,
        ),
      ),
    );
  }
}
