import 'package:flutter/material.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/topic.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final TopicService _topicService = TopicService();
  List<Topic> _topics = []; 

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    _topics = await _topicService.loadTopics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Danh sách Đề tài", style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ..._topics.map(_buildTopicCard),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(Topic topic) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.btnColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Text(topic.TenChuDe, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.white), onPressed: () => _editTopic(context, topic)),
            IconButton(icon: Icon(Icons.delete, color: Colors.white), onPressed: () => _deleteTopic(context, topic)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addTopic(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 6,
        ),
        child: Text("Thêm Đề tài", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Future<void> _addTopic(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Thêm Đề tài', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Tên Đề tài', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy', style: TextStyle(color: Colors.red))),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  int newChuDeID = (_topics.isNotEmpty ? _topics.last.ChuDe_ID + 1 : 0); // Tính toán ChuDe_ID mới
                  await _topicService.addTopic(titleController.text, newChuDeID);
                  await _loadTopics();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập tên đề tài')));
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTopic(BuildContext context, Topic topic) async {
    final TextEditingController titleController = TextEditingController()..text = topic.TenChuDe;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Chỉnh sửa Đề tài', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Tên Đề tài', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy', style: TextStyle(color: Colors.red))),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await _topicService.updateTopic(topic.ChuDe_ID, titleController.text);
                  await _loadTopics();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập tên đề tài')));
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTopic(BuildContext context, Topic topic) async {
    await _topicService.deleteTopic(topic.ChuDe_ID);
    await _loadTopics();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa ${topic.TenChuDe}')));
  }
}
