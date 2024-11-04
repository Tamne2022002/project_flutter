import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe.dart';
import 'package:project_flutter/authen/service.dart';

import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/authen/login_screen.dart';

import 'ChuDe/ChuDe_Screen.dart'; // Import màn hình Topics
import 'TaiKhoan/TaiKhoan_Screen.dart'; // Import màn hình Accounts
import 'CauHoi/CauHoi_Screen.dart'; // Import màn hình Questions

class AdminDashboard extends StatelessWidget {
  final auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        
        title: Text(
          "Admin Dashboard",
          
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        backgroundColor:AppColors.btnColor, // Màu nền appBar
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () { 
              // Chức năng đăng xuất
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildListTile(context, 'Danh sách Chủ Đề', TopicsScreen(), Icons.topic),
            _buildListTile(context, 'Danh sách Bộ Đề', BoDeScreen(), Icons.book),
            _buildListTile(context, 'Danh sách Tài Khoản', AccountsScreen(), Icons.account_circle),
            _buildListTile(context, 'Danh sách Câu Hỏi', QuestionsScreen(), Icons.question_answer),
          ],
        ),
      ),
    );
  }

  // Tạo ListTile cho mỗi mục
  Widget _buildListTile(BuildContext context, String title, Widget screen, IconData icon) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bo góc Card
      ),
      color: AppColors.btnColor, // Màu nền của card
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Row(
          children: [
            Icon(icon, color: Colors.white), // Thêm icon cho mỗi mục
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                
                color: Colors.white, // Màu chữ
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white, // Màu icon
        ),
        onTap: () {
          // Chuyển màn hình khi nhấn vào mục
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }

  // Hiển thị Dialog đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async{
                // Thực hiện đăng xuất và điều hướng về màn hình đăng nhập
                Navigator.pop(context); // Đóng dialog
                auth.signout(); //Đăng xuất ra
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );// Chuyển đến màn hình đăng nhập
              },
              child: Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
