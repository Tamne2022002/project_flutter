import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';

class AddBoDeScreen extends StatefulWidget {
  final List<String> chuDeList;
  final Function(BoDe) onSave;

  AddBoDeScreen({required this.chuDeList, required this.onSave});

  @override
  _AddBoDeScreenState createState() => _AddBoDeScreenState();
}

class _AddBoDeScreenState extends State<AddBoDeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? chuDeId;
  int soLuongCau = 0;
  int trangThai = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Thêm Bộ đề'),
        backgroundColor: AppColors.btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
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
                style: TextStyle(color: Colors.white), // Màu chữ
                onChanged: (value) {
                  setState(() {
                    chuDeId = value;
                  });
                },
                items: List.generate(
                  widget.chuDeList.length,
                  (index) => DropdownMenuItem(
                    value: index + 1, // chuDeId bắt đầu từ 1
                    child: Text(widget.chuDeList[index]),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn chủ đề';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số lượng câu',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Màu chữ
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    soLuongCau = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Vui lòng nhập số lượng câu hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(BoDe(
                      boDeId: DateTime.now()
                          .millisecondsSinceEpoch, // Tạo ID ngẫu nhiên
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
