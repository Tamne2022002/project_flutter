import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';

import 'package:project_flutter/model/bode.dart';

class EditBoDeScreen extends StatefulWidget {
  final BoDe boDe;
  final List<String> chuDeList;
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

  @override
  void initState() {
    super.initState();
    // Khởi tạo các giá trị từ boDe hiện tại
    chuDeId = widget.boDe.chuDeId;
    soLuongCau = widget.boDe.soLuongCau;
    trangThai = widget.boDe.trangThai;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Chỉnh sửa Bộ đề',style: TextStyle(color: Colors.white),),
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
                value: chuDeId,
                                style: TextStyle(color: Colors.white), 
                decoration: InputDecoration(
                  labelText: 'Chủ đề',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.btnColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.btnColor),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    chuDeId = value;
                  });
                },
                items: List.generate(
                  widget.chuDeList.length,
                  (index) => DropdownMenuItem(
                    value: index + 1, // Giả sử chuDeId bắt đầu từ 1
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
              
              // TextField cho số lượng câu
              TextFormField(
                initialValue: soLuongCau.toString(),
                decoration: InputDecoration(
                  labelText: 'Số lượng câu',
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

              // Nút Lưu
              ElevatedButton(
                
                onPressed: () {
                  
                  if (_formKey.currentState!.validate()) {
                    // Cập nhật lại thông tin bộ đề
                    widget.onSave(BoDe(
                      boDeId: widget.boDe.boDeId, // Giữ nguyên ID bộ đề
                      chuDeId: chuDeId!,
                      soLuongCau: soLuongCau,
                      createAt: widget.boDe.createAt, // Giữ nguyên thời gian tạo
                      updateAt: DateTime.now(), // Cập nhật thời gian sửa đổi
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
