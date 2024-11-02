import 'package:flutter/material.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';

class AddBoDeScreen extends StatefulWidget {
  final Function(BoDe) onSave;

  AddBoDeScreen({required this.onSave, required List<Topic> chuDeList}); 

  @override
  _AddBoDeScreenState createState() => _AddBoDeScreenState();
}

class _AddBoDeScreenState extends State<AddBoDeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? chuDeId;
  int soLuongCau = 0;
  int trangThai = 1;
  List<Topic> chuDeList = [];
  List<BoDe> boDeList = [];
  
  bool isLoading = true;
  final BoDeService boDeService = BoDeService();

  @override
  void initState() {
    super.initState();
    loadTopics();
    _loadBoDes(); // Gọi hàm tải bộ đề
  }

  Future<void> _loadBoDes() async {
    boDeList = await boDeService.loadBoDes();
    setState(() {
      isLoading = false;
    });
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
              isLoading
                  ? CircularProgressIndicator()
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
              SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Gán ID mới cho bộ đề
                    int newBoDeId = await boDeService.getMaxBoDeId()+1;

                    BoDe newBoDe = BoDe(
                      boDeId: newBoDeId,
                      chuDeId: chuDeId!,
                      soLuongCau: soLuongCau,
                      createAt: DateTime.now(),
                      updateAt: DateTime.now(),
                      trangThai: trangThai,
                    );

                    // Gọi hàm thêm bộ đề
                    await boDeService.addBoDe(newBoDe);

                    // Thực hiện callback
                    widget.onSave(newBoDe);
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
