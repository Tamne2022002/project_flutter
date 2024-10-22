import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/topic.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final List<Topic> _topics = [
    Topic(title: 'Đề tài 1', questionCount: 5),
    Topic(title: 'Đề tài 2', questionCount: 10),
    Topic(title: 'Đề tài 3', questionCount: 7),
  ];

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text(
          "Danh sách Đề tài",
          style: TextStyle(fontSize: 22,color: Colors.white),
        ),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white), // Màu nền appBar
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Hiển thị danh sách đề tài
            ..._topics.map((topic) => _buildTopicCard(topic)),
            // Nút Thêm Đề tài
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  // Card cho từng Đề tài
  Widget _buildTopicCard(Topic topic) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bo góc card mềm mại
      ),
      color: AppColors.btnColor, // Màu nền card
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ
              ),
            ),
            SizedBox(height: 6),
            Text(
              '${topic.questionCount} câu hỏi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Màu chữ cho số lượng câu hỏi
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nút Sửa
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editTopic(context, topic),
            ),
            // Nút Xóa
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteTopic(context, topic),
            ),
          ],
        ),
      ),
    );
  }

  // Nút Thêm Đề tài
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addTopic(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor, // Màu nền button
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bo góc button
          ),
          elevation: 6, // Độ nổi của button
        ),
        child: Text(
          "Thêm Đề tài",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Thêm Đề tài
  Future<void> _addTopic(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bo góc hộp thoại
          ),
          title: Text('Thêm Đề tài', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Tên Đề tài',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng dialog
              child: Text('Hủy', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _topics.add(Topic(title: titleController.text, questionCount: 0));
                  });
                  Navigator.pop(context); // Đóng dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập tên đề tài')),
                  );
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Sửa Đề tài
  Future<void> _editTopic(BuildContext context, Topic topic) async {
    final TextEditingController titleController = TextEditingController();
    titleController.text = topic.title;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bo góc hộp thoại
          ),
          title: Text('Chỉnh sửa Đề tài', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Tên Đề tài',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng dialog
              child: Text('Hủy', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    topic.title = titleController.text; // Cập nhật tiêu đề
                  });
                  Navigator.pop(context); // Đóng dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập tên đề tài')),
                  );
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Xóa Đề tài
  void _deleteTopic(BuildContext context, Topic topic) {
    setState(() {
      _topics.remove(topic); // Xóa đề tài khỏi danh sách
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa ${topic.title}')), // Thông báo xóa
    );
  }
}
