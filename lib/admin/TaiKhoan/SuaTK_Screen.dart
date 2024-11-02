import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/service.dart'; // Nhập AuthService để sử dụng hàm cập nhật

class EditAccountScreen extends StatefulWidget {
  final Account account;
  final Function(Account) onSave;

  EditAccountScreen({required this.account, required this.onSave});

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController roleController;

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.account.name);
    emailController = TextEditingController(text: widget.account.email);
    phoneController = TextEditingController(text: widget.account.phone);
    roleController =
        TextEditingController(text: widget.account.role.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Chỉnh sửa Tài khoản',
            style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(
                    nameController, 'Tên tài khoản', Icons.account_circle),
                SizedBox(height: 16),
                _buildTextFormField(emailController, 'Email', Icons.email,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: 16),
                _buildTextFormField(
                    phoneController, 'Số điện thoại', Icons.phone,
                    keyboardType: TextInputType.phone),
                SizedBox(height: 16),
                _buildTextFormField(roleController, 'Quyền hạn', Icons.security,
                    keyboardType: TextInputType.number),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.btnColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(
                          "Updating account: id=${widget.account.id}, name=${nameController.text}, email=${emailController.text}, phone=${phoneController.text}, role=${roleController.text}"); // In giá trị ra
                      bool success = await _authService.updateAccount(
                        widget.account.id,
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        int.tryParse(roleController.text) ?? 0,
                      );
                      if (success) {
                        // Gọi callback onSave với thông tin đã cập nhật
                        widget.onSave(Account(
                          id: widget.account.id, // Giữ ID cũ
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          role: int.tryParse(roleController.text) ?? 0,
                          xp: widget.account.xp, // Giữ giá trị XP cũ
                        ));
                        Navigator.pop(context);
                      } else {
                        // Xử lý lỗi nếu không cập nhật thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cập nhật thất bại!')),
                        );
                      }
                    }
                  },
                  child: Text('Lưu',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget tái sử dụng cho các trường nhập liệu
  Widget _buildTextFormField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }
}
