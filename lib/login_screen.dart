import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/admin/admin_screen.dart';
import 'package:project_flutter/forgot_password_screen.dart';
import 'package:project_flutter/register_sceen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Widget _buildTextField(String label, IconData icon, bool isPassword) {
    return TextFormField(
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF341C4D),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Chào mừng',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 48.0,
                      color: Colors.white),
                ),
                Text(
                  'hãy đăng nhập tài khoản của bạn',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                      color: Colors.white),
                ),
                SizedBox(height: 25),
                _buildTextField('Tên đăng nhập', Icons.email, false),
                SizedBox(height: 20),
                _buildTextField('Mật khẩu', Icons.password, true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                          print('Forgot Password!');
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminDashboard()),
                      );
                    },
                    color: Color(0xFF998DA6),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Divider(color: Colors.white, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''Bạn chưa có tài khoản ''',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RegisterSceen()),
                        );
                        print('Sign Up');
                      },
                      child: Text('Đăng ký ngay'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
