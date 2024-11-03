import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChiTietBoDeScreen extends StatefulWidget {
  final int boDeId;
  final int maxSoLuongCau; // Số lượng câu hỏi tối đa cho bộ đề
  final int chuDeId; // ID của chủ đề
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
  List<Question> selectedQuestions = []; // Danh sách câu hỏi đã chọn
  int trangThai = 1;
  final BoDeService boDeService = BoDeService(); // Tạo một instance của BoDeService

  @override
  void initState() {
    super.initState();
    // Tải câu hỏi từ Firestore theo chủ đề
    _loadQuestions();
  }

Future<void> _loadQuestions() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('CauHoi')
        .where('ChuDe_ID', isEqualTo: widget.chuDeId)
        .get();

    List<Question> questions = snapshot.docs.map((doc) {
      return Question.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    // Lọc ra các câu hỏi chưa được chọn
    List<Question> availableQuestions = questions.where((question) {
      return !selectedQuestions.any((selected) => selected.CauHoi_ID == question.CauHoi_ID);
    }).toList();

    // Kiểm tra số lượng chi tiết câu hỏi hiện có
    int existingCount = await boDeService.getChiTietBoDeCount(widget.boDeId);

    // Tính số câu hỏi tối đa có thể thêm vào
    int maxQuestionsToAdd = widget.maxSoLuongCau - existingCount - selectedQuestions.length;

    // Kiểm tra nếu số lượng câu hỏi đã chọn còn nhỏ hơn maxSoLuongCau
    if (maxQuestionsToAdd > 0) {
      // Nếu có câu hỏi chưa được chọn, chọn ngẫu nhiên và thêm vào danh sách
      if (availableQuestions.isNotEmpty) {
        // Chọn ngẫu nhiên các câu hỏi
        for (int i = 0; i < maxQuestionsToAdd; i++) {
          if (availableQuestions.isEmpty) break; // Dừng nếu không còn câu hỏi
          
          int randomIndex = (availableQuestions.length * DateTime.now().millisecondsSinceEpoch).toInt() % availableQuestions.length;
          setState(() {
            selectedQuestions.add(availableQuestions[randomIndex]);
            // Xóa câu hỏi đã chọn ra khỏi danh sách có sẵn
            availableQuestions.removeAt(randomIndex);
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
        int newCTbode_ID = await boDeService.getCTMaxBoDeId()+1;
        ChiTietBoDe chiTietBoDe = ChiTietBoDe(
          chiTietBoDeId:newCTbode_ID ,
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
        SnackBar(content: Text('Số lượng câu hỏi đã vượt quá giới hạn cho phép!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Thêm Chi tiết Bộ đề", style: TextStyle(color: Colors.white)),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                child: Text('Thêm Câu Hỏi Ngẫu Nhiên', style: TextStyle(color: Colors.white)),
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
