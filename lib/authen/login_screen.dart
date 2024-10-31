import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/admin/admin_screen.dart';
import 'package:project_flutter/authen/forgot_password_screen.dart';
import 'package:project_flutter/authen/register_sceen.dart';
import 'package:project_flutter/authen/service.dart';
import 'package:project_flutter/layout/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final passWord = TextEditingController();
  final auth = AuthService();

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
                      fontSize: 22.0, color: Colors.white),
                ),
                SizedBox(height: 25),
                _buildTextField('Tên đăng nhập', Icons.email, false, email),
                SizedBox(height: 20),
                _buildTextField('Mật khẩu', Icons.password, true, passWord),
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
                    onPressed: _login,
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
                              builder: (context) => RegisterScreen()),
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

  Widget _buildTextField(String label, IconData icon, bool isPassword, TextEditingController input) {
    return TextFormField(
      controller: input,
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

_login() async {
  final user = await auth.loginUserWithEmailAndPassword(email.text, passWord.text);
  if (user != null) {
    // Lấy thông tin người dùng từ Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('NguoiDung').doc(user.uid).get();

    if (userDoc.exists) {
      // Lấy giá trị phanQuyen_ID
      int phanQuyenID = userDoc['phanQuyen_ID'];

      if (phanQuyenID == 1) {
        // Phân quyền là 1, chuyển đến AdminDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else if (phanQuyenID == 0) {
        // Phân quyền là 0, chuyển đến HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Phân quyền không hợp lệ
        _showSnackBar("Phân quyền không hợp lệ!", Colors.red);
      }
    } else {
      _showSnackBar("Không tìm thấy thông tin người dùng!", Colors.red);
    }
  } else {
    // Đăng nhập thất bại, hiển thị thông báo
    _showSnackBar("Đăng nhập thất bại. Vui lòng kiểm tra lại tài khoản!", Colors.red);
  }
}

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
