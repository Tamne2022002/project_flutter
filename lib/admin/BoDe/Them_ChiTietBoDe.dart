import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChiTietBoDeScreen extends StatefulWidget {
  final int boDeId;
  final int maxSoLuongCau; 
  final int chuDeId; 
  final Function(ChiTietBoDe) onSave;

  AddChiTietBoDeScreen({
    required this.boDeId,
    required this.maxSoLuongCau,
    required this.chuDeId,
    required this.onSave,
  });

  @override
  _AddChiTietBoDeScreenState createState() => _AddChiTietBoDeScreenState();
}

class _AddChiTietBoDeScreenState extends State<AddChiTietBoDeScreen> {
  List<Question> selectedQuestions = []; 
  int trangThai = 1;
  final BoDeService boDeService =
      BoDeService(); 

  @override
  void initState() {
    super.initState();
   
    _loadQuestions();
  }




Future<void> _loadQuestions() async {
  try {
    //  Lấy danh sách câu hỏi đã chọn từ ChiTietBoDe
    List<int> selectedQuestionIds = await boDeService.getSelectedQuestionIds(widget.boDeId);

    //  Tải câu hỏi từ Firestore theo chủ đề
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('CauHoi')
        .where('ChuDe_ID', isEqualTo: widget.chuDeId)
        .get();

    List<Question> questions = snapshot.docs.map((doc) {
      return Question.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    //  Lọc bỏ các câu hỏi đã chọn trong ChiTietBoDe
    List<Question> availableQuestions = questions.where((question) {
      return !selectedQuestionIds.contains(question.CauHoi_ID) &&
             !selectedQuestions.any((selected) => selected.CauHoi_ID == question.CauHoi_ID);
    }).toList();

    // Kiểm tra số lượng câu hỏi có thể thêm vào
    int existingCount = await boDeService.getChiTietBoDeCount(widget.boDeId);
    int maxQuestionsToAdd = widget.maxSoLuongCau - existingCount - selectedQuestions.length;

    // Thêm các câu hỏi chưa được chọn vào danh sách
    if (maxQuestionsToAdd > 0) {
      if (availableQuestions.isNotEmpty) {
        for (int i = 0; i < maxQuestionsToAdd; i++) {
          if (availableQuestions.isEmpty) break;
          setState(() {
            selectedQuestions.add(availableQuestions.first);
            availableQuestions.removeAt(0);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tất cả câu hỏi đã được chọn!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số lượng câu hỏi đã đạt tối đa!')),
      );
    }
  } catch (e) {
    print("Error loading questions: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Không thể tải câu hỏi!')),
    );
  }
}


  Future<void> _addChiTietBoDe() async {
    // Kiểm tra số lượng chi tiết câu hỏi đã có trong ChiTietBoDe
    int existingCount = await boDeService.getChiTietBoDeCount(widget.boDeId);

    // Nếu số lượng câu hỏi đã chọn cộng với số lượng đã có nhỏ hơn hoặc bằng maxSoLuongCau
    if (existingCount + selectedQuestions.length <= widget.maxSoLuongCau) {
      for (var question in selectedQuestions) {
        int newCTbode_ID = await boDeService.getCTMaxBoDeId() + 1;
        ChiTietBoDe chiTietBoDe = ChiTietBoDe(
          chiTietBoDeId: newCTbode_ID,
          cauHoiId: question.CauHoi_ID,
          boDeId: widget.boDeId,
          createAt: DateTime.now(),
          updateAt: DateTime.now(),
          trangThai: trangThai,
        );

        await boDeService.addChiTietBoDe(chiTietBoDe);
        widget.onSave(chiTietBoDe);
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Số lượng câu hỏi đã vượt quá giới hạn cho phép!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title:
            Text("Thêm Chi tiết Bộ đề", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        selectedQuestions[index].NoiDung_CauHoi,
                        style: TextStyle(color: Colors.white),
                      ),
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
            // Nút thêm câu hỏi ngẫu nhiên
            if (selectedQuestions.length < widget.maxSoLuongCau)
              ElevatedButton(
                onPressed: () async {
                  await _loadQuestions();
                },
                child: Text('Thêm Câu Hỏi Ngẫu Nhiên',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                ),
              ),
            SizedBox(height: 20),
            // Nút Lưu
            ElevatedButton(
              onPressed: _addChiTietBoDe,
              child: Text('Lưu', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
