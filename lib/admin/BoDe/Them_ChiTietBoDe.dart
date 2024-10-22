import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/question.dart';
// Giả sử bạn có model CauHoi

class AddChiTietBoDeScreen extends StatefulWidget {
  final int boDeId;
  final int maxSoLuongCau; // Thêm số lượng câu hỏi tối đa cho bộ đề
  final Function(ChiTietBoDe) onSave;

  AddChiTietBoDeScreen({required this.boDeId, required this.maxSoLuongCau, required this.onSave});

  @override
  _AddChiTietBoDeScreenState createState() => _AddChiTietBoDeScreenState();
}

class _AddChiTietBoDeScreenState extends State<AddChiTietBoDeScreen> {
  List<Question> cauHoiList = [
    Question(title: 'Câu hỏi 1', topic: 'Toán', answers: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
    Question(title: 'Câu hỏi 2', topic: 'Vật lý', answers: ['A', 'B', 'C', 'D'], correctAnswerIndex: 1),
    Question(title: 'Câu hỏi 3', topic: 'Hóa học', answers: ['A', 'B', 'C', 'D'], correctAnswerIndex: 2),
  ];
  
  List<Question> selectedQuestions = []; // Danh sách các câu hỏi đã chọn
  int trangThai = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Thêm Chi tiết Bộ đề",style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị danh sách câu hỏi đã chọn
            Expanded(
              child: ListView.builder(
                itemCount: selectedQuestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.btnColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(selectedQuestions[index].title,style: TextStyle(color: Colors.white),),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedQuestions.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Nút cộng để thêm câu hỏi mới
            if (selectedQuestions.length < widget.maxSoLuongCau)
              ElevatedButton(
                onPressed: () {
                  if (selectedQuestions.length < widget.maxSoLuongCau) {
                    setState(() {
                      // Thêm câu hỏi mới vào danh sách
                      selectedQuestions.add(cauHoiList[selectedQuestions.length]);
                    });
                  } else {
                    // Hiển thị thông báo nếu đã đạt giới hạn số lượng câu hỏi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Số câu hỏi đã đạt giới hạn tối đa!'),
                      ),
                    );
                  }
                },
                child: Text('Thêm Câu Hỏi',style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                ),
              ),
          
            SizedBox(height: 20),
            // Nút Lưu
            ElevatedButton(
          
              onPressed: () {
                if (selectedQuestions.isNotEmpty) {
                  // Lưu các chi tiết bộ đề với câu hỏi đã chọn
                  selectedQuestions.forEach((question) {
                    widget.onSave(ChiTietBoDe(
                      chiTietBoDeId: DateTime.now().millisecondsSinceEpoch, // Tạo ID ngẫu nhiên
                      questionTitle: question.title, // Lưu title câu hỏi
                      boDeId: widget.boDeId,
                      createAt: DateTime.now(),
                      updateAt: DateTime.now(),
                      trangThai: trangThai,
                    ));
                  });

                  Navigator.pop(context);
                }
              },
              child: Text('Lưu',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.btnColor),
              
            ),
          ],
        ),
      ),
    );
  }
}
