import 'package:flutter/material.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/topic.dart';



class AddBoDeScreen extends StatefulWidget {
  final Function(BoDe) onSave;

  AddBoDeScreen({required this.onSave, required List<String> chuDeList});

  @override
  _AddBoDeScreenState createState() => _AddBoDeScreenState();
}

class _AddBoDeScreenState extends State<AddBoDeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? chuDeId;
  int soLuongCau = 0;
  int trangThai = 1;
  List<Topic> chuDeList = []; // Danh sách các Topic
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  Future<void> loadTopics() async {
    TopicService topicService = TopicService();
    // Giả sử loadTopics trả về List<Topic>
    chuDeList = await topicService.loadTopics(); 
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Thêm Bộ đề', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown cho chủ đề
              isLoading
                  ? CircularProgressIndicator() // Hiển thị loading nếu đang tải
                  : DropdownButtonFormField<int>(
                      dropdownColor: AppColors.btnColor,
                      value: chuDeId,
                      decoration: InputDecoration(
                        labelText: 'Chủ đề',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.btnColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.btnColor),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          chuDeId = value;
                        });
                      },
                      items: chuDeList.map((topic) {
                        return DropdownMenuItem<int>(
                          value: topic.ChuDe_ID, // Gán chuDeId cho giá trị
                          child: Text(topic.TenChuDe),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Vui lòng chọn chủ đề';
                        }
                        return null;
                      },
                    ),
              SizedBox(height: 20),
              // TextField cho số lượng câu
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số lượng câu',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.btnColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.btnColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    soLuongCau = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Vui lòng nhập số lượng câu hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Nút Lưu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Gọi hàm lưu nếu tất cả các trường hợp hợp lệ
                    widget.onSave(BoDe(
                      boDeId: DateTime.now().millisecondsSinceEpoch,
                      chuDeId: chuDeId!,
                      soLuongCau: soLuongCau,
                      createAt: DateTime.now(),
                      updateAt: DateTime.now(),
                      trangThai: trangThai,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
