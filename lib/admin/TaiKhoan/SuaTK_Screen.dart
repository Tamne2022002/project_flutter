import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';


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
  late TextEditingController passwordController;
  late TextEditingController roleController;
  late TextEditingController xpController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.account.name);
    emailController = TextEditingController(text: widget.account.email);
    phoneController = TextEditingController(text: widget.account.phone);
    passwordController = TextEditingController(text: widget.account.password);
    roleController =
        TextEditingController(text: widget.account.role.toString());
    xpController = TextEditingController(text: widget.account.xp.toString());
  }

  // Kiểm tra định dạng email
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Kiểm tra định dạng số điện thoại (10-11 chữ số)
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$');
    return phoneRegex.hasMatch(phone);
  }

  // Kiểm tra nhập số cho Role và XP
  bool _isValidNumber(String value) {
    return int.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Chỉnh sửa Tài khoản', style: TextStyle(fontSize: 22,color: Colors.white)),
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
                _buildTextFormField(passwordController, 'Mật khẩu', Icons.lock,
                    obscureText: true),
                SizedBox(height: 16),
                _buildTextFormField(roleController, 'Quyền hạn', Icons.security,
                    keyboardType: TextInputType.number),
                SizedBox(height: 16),
                _buildTextFormField(xpController, 'Điểm XP', Icons.star,
                    keyboardType: TextInputType.number),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.btnColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(Account(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                        role: int.tryParse(roleController.text) ?? 0,
                        xp: int.tryParse(xpController.text) ?? 0,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Lưu', style: TextStyle(fontSize: 18,color: Colors.white)),
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
      style: TextStyle(color: Colors.white), // Màu chữ
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white), // Màu chữ label
        prefixIcon: Icon(icon, color: Colors.white), // Màu icon
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // Viền trắng
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Viền trắng khi có focus
        ),
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
