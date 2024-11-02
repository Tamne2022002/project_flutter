import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/service.dart'; // Import AuthService

class AddAccountScreen extends StatefulWidget {
  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController roleController;

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    roleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text('Thêm Tài khoản',
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
                _buildTextFormField(passwordController, 'Mật khẩu', Icons.lock,
                    obscureText: true),
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
                      int phanQuyenID = int.tryParse(roleController.text) ?? 0;

                      // Gọi hàm createAdminUser
                      final user = await _authService.createAdminUser(
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        passwordController.text,
                        phanQuyenID,
                      );

                      if (user != null) {
                        // Trả về Account mới được tạo
                        Account newAccount = Account(
                        
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                          role: phanQuyenID,
                          xp: 0, // XP không cần thiết
                        );

                        Navigator.pop(context, newAccount); // Trả về Account
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tạo tài khoản thất bại!')),
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
