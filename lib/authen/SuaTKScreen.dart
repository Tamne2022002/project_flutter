import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/qlTaiKhoan.dart';
import 'package:project_flutter/authen/service.dart'; // Nhập AuthService để sử dụng hàm cập nhật

class SuaTaikhoanScreen extends StatefulWidget {
  final Account? account;
  final Function(Account) onSave;

  SuaTaikhoanScreen({required this.account, required this.onSave});
  //const SuaTaikhoanScreen({super.key, required this.account});

  @override
  State<SuaTaikhoanScreen> createState() => _SuaTaikhoanScreenState();
}

class _SuaTaikhoanScreenState extends State<SuaTaikhoanScreen> {
  late TextEditingController nameController =
      TextEditingController(text: "${widget.account?.name ?? ""}");
  late TextEditingController phoneController =
      TextEditingController(text: "${widget.account?.phone ?? ""}");

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  @override
  void initState() {
    super.initState();
    // log(widget.account.toString());
  }

  @override
  void dispose() {
    nameController.dispose(); // Giải phóng bộ nhớ khi không dùng nữa
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "CẬP NHẬT THÔNG TIN",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tên tài khoản',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon:
                          Icon(Icons.account_circle, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập Tên tài khoản';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: phoneController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập Số điện thoại';
                      }
                      if (value.length != 10) {
                        return 'Số điện thoại phải là 10 số';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppColors.btnColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        int? accountId = widget.account?.id;
                        String? _email = widget.account?.email;
                        int? accountRole = widget.account?.role;
                        int? accountXp = widget.account?.xp;
                        print(
                            "Updating account: name=${nameController.text},phone=${phoneController.text}");
                        bool success = await _authService.updateTaiKhoan(
                          accountId ?? 0,
                          nameController.text,
                          phoneController.text,
                        );
                        if (success) {
                          // Gọi callback onSave với thông tin đã cập nhật
                          widget.onSave(Account(
                            name: nameController.text,
                            email: _email ?? "",
                            phone: phoneController.text,
                            role: accountRole ?? 0,
                            xp: accountXp ?? 0,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Cập nhật thành công!"),
                                duration: Duration(seconds: 1)),
                          );
                          // Đợi một khoảng thời gian (ở đây là 1 giây) trước khi quay lại trang trước
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context); // Quay lại trang trước
                          });
                        } else {
                          // Xử lý lỗi nếu không cập nhật thành công
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cập nhật thất bại!'), 
                            duration: Duration(seconds: 1)),
                          );
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context); // Quay lại trang trước
                          });
                        }
                      }
                    },
                    child: Text('Cập nhật',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ])
              ],
            )),
      ),
    );
  }
}
