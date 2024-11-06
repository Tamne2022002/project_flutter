import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/topic.dart';

class EditBoDeScreen extends StatefulWidget {
  final BoDe boDe;
  final List<Topic> chuDeList;
  final Function(BoDe) onSave;

  EditBoDeScreen({
    required this.boDe,
    required this.chuDeList,
    required this.onSave,
  });

  @override
  _EditBoDeScreenState createState() => _EditBoDeScreenState();
}

class _EditBoDeScreenState extends State<EditBoDeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? chuDeId;
  int soLuongCau = 0;
  int trangThai = 1;
  List<Topic> chuDeList = [];
  bool isLoading = true;
  final BoDeService boDeService = BoDeService();

  @override
  void initState() {
    super.initState();
    chuDeId = widget.boDe.chuDeId; // Khởi tạo giá trị cho chuDeId
    soLuongCau = widget.boDe.soLuongCau; // Khởi tạo giá trị cho soLuongCau
    loadTopics();
  }

  Future<void> loadTopics() async {
    TopicService topicService = TopicService();
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
        title: Text('Chỉnh sửa Bộ đề', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown cho chủ đề
              DropdownButtonFormField<int>(
                dropdownColor: AppColors.btnColor,
                value: chuDeId,
                decoration: InputDecoration(
                  labelText: 'Chủ đề',
                   labelStyle: TextStyle(color: Colors.white),
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
                    print("Chủ đề ID đã thay đổi: $chuDeId"); // Kiểm tra giá trị mới
                  });
                },
                items: chuDeList.map((topic) {
                  return DropdownMenuItem<int>(
                    value: topic.ChuDe_ID,
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
              SizedBox(height: 15,),
              
              // TextField cho số lượng câu
              TextFormField(
                initialValue: soLuongCau.toString(),
                decoration: InputDecoration(
                  labelText: 'Số lượng câu',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Kiểm tra xem chuDeId có thay đổi hay không
                    if (chuDeId != widget.boDe.chuDeId) {
                      print("ChuDeId đã thay đổi từ ${widget.boDe.chuDeId} thành $chuDeId");
                    }

                    // Cập nhật lại thông tin bộ đề
                    BoDe updatedBoDe = BoDe(
                      boDeId: widget.boDe.boDeId, // Giữ nguyên ID bộ đề
                      chuDeId: chuDeId!,
                      soLuongCau: soLuongCau,
                      createAt: widget.boDe.createAt,
                      updateAt: DateTime.now(),
                      trangThai: trangThai,
                    );

                    // Gọi phương thức cập nhật
                    await boDeService.updateBoDe(updatedBoDe);
                    widget.onSave(updatedBoDe); // Gọi callback để cập nhật UI
                     Navigator.pop(context, updatedBoDe);
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
