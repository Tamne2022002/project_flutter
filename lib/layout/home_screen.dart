import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/authen/qlTaiKhoan.dart';
import 'package:project_flutter/authen/login_screen.dart';
import 'package:project_flutter/authen/service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/button_game.dart';
import 'package:project_flutter/layout/history/Lichsu_screen.dart';
import 'package:project_flutter/layout/mode_screen.dart';
import 'package:project_flutter/friends/timkiembanbe.dart';
import 'package:project_flutter/friends/DS_Friend.dart';

class HomeScreen extends StatelessWidget {
  final int idUser;
  final auth = AuthService();
  HomeScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountsScreen()));
            },
          ),
          Center(
              child: Text('TRANG CHỦ',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ]),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, size: 120, color: Colors.white),
            const SizedBox(height: 60),
            CustomButton(
              icon: Icons.play_arrow,
              text: 'Tham gia ngay',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ModeScreen(idUser: idUser),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Start from the right
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            CustomButton(
              icon: Icons.people,
              text: 'Danh sách bạn',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendScreen()),
                );
              },
            ),
            CustomButton(
              icon: Icons.person_add,
              text: 'Thêm bạn bè',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchUserScreen()),
                );
              },
            ),
            CustomButton(
              icon: Icons.history,
              text: 'Lịch sử chơi',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
            ),
          ],
        ),
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
              onPressed: () async {
                // Thực hiện đăng xuất và điều hướng về màn hình đăng nhập
                Navigator.pop(context); // Đóng dialog
                auth.signout(); //Đăng xuất ra
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ); // Chuyển đến màn hình đăng nhập
              },
              child: Text('Đăng xuất', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
