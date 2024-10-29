import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/authen/service.dart';
import 'package:project_flutter/color/Color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = AuthService();
  final HoTen = TextEditingController();
  final Email = TextEditingController();
  final SDT = TextEditingController();
  final MatKhau = TextEditingController();
  final XacNhanMK = TextEditingController();

  @override
  void dispose() {
    HoTen.dispose();
    Email.dispose();
    SDT.dispose();
    MatKhau.dispose();
    XacNhanMK.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: AppColors.backColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'ĐĂNG KÝ',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 48.0, color: Colors.white),
              ),
              const SizedBox(height: 25),
              _buildTextField('Họ tên', Icons.person, HoTen),
              const SizedBox(height: 20),
              _buildTextField('Email', Icons.email, Email),
              const SizedBox(height: 20),
              _buildTextField('Số điện thoại', Icons.phone, SDT),
              const SizedBox(height: 20),
              _buildTextField('Mật khẩu', Icons.lock, MatKhau, true),
              const SizedBox(height: 20),
              _buildTextField('Xác nhận mật khẩu', Icons.lock, XacNhanMK, true),
              const SizedBox(height: 15),
              _registerButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, [bool obscureText = false]) {
    return TextFormField(
      keyboardType: obscureText ? TextInputType.visiblePassword : TextInputType.emailAddress,
      obscureText: obscureText,
      controller: controller,
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

  Widget _registerButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: MaterialButton(
        onPressed: _signup,
        color: AppColors.btnColor,
        child: Text('Đăng ký', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  _signup() async {
    if (MatKhau.text.length < 6) {
      _showSnackBar('Mật khẩu phải có ít nhất 6 ký tự!', Colors.red);
      return;
    }

    try {
      final user = await auth.createUserWithEmailAndPassword(
        HoTen.text,
        Email.text,
        SDT.text,
        MatKhau.text,
        XacNhanMK.text,
      );

      if (user != null) {
        _showSnackBar('Đăng ký thành công!', AppColors.btnColor);
        log("Đăng ký thành công");
      }
    } catch (e) {
      _showSnackBar('Đăng ký thất bại: ${e.toString()}', AppColors.btnColor);
      log("Đăng ký thất bại: $e");
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
