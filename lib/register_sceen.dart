import 'package:flutter/material.dart';

import 'package:project_flutter/color/Color.dart';

class RegisterSceen extends StatefulWidget {
  const RegisterSceen({super.key});

  @override
  State<RegisterSceen> createState() => _RegisterSceenState();
}

class _RegisterSceenState extends State<RegisterSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'ĐĂNG KÝ',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 60.0,
                      color: Colors.white),
                ),
                const SizedBox(height: 25),
                _buildTextField(label: 'Họ tên', icon: Icons.person),
                const SizedBox(height: 20),
                _buildTextField(label: 'Email', icon: Icons.email),
                const SizedBox(height: 20),
                _buildTextField(label: 'Số điện thoại', icon: Icons.phone),
                const SizedBox(height: 20),
                _buildTextField(label: 'Mật khẩu', icon: Icons.lock, obscureText: true),
                const SizedBox(height: 20),
                _buildTextField(label: 'Xác nhận mật khẩu', icon: Icons.lock, obscureText: true),
                const SizedBox(height: 15),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () => print("Successful Registration."),
                    color: AppColors.btnColor,
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool obscureText = false}) {
    return TextFormField(
      keyboardType: obscureText ? TextInputType.visiblePassword : TextInputType.emailAddress,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
