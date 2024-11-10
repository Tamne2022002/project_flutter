import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/qlTaiKhoan.dart';
import 'package:project_flutter/authen/service.dart'; // Nhập AuthService để sử dụng hàm cập nhật


class ChangePasswordScreen extends StatefulWidget {
  final Account? account;
  final Function(Account) onSave;

  ChangePasswordScreen({required this.account, required this.onSave});
  //const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
   final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // log(widget.account.toString());
  }

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.btnColor,
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "ĐỔI MẬT KHẨU",
//           style: TextStyle(fontSize: 30, color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _newPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                       labelText: 'Mật khẩu mới',
//                       labelStyle: TextStyle(color: Colors.white),
//                       prefixIcon:
//                           Icon(Icons.account_circle, color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                     ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập mật khẩu mới';
//                   } else if (value.length < 6) {
//                     return 'Mật khẩu phải có ít nhất 6 ký tự';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                       labelText: 'Xác nhận mật khẩu mới',
//                       labelStyle: TextStyle(color: Colors.white),
//                       prefixIcon:
//                           Icon(Icons.account_circle, color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                     ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng xác nhận mật khẩu mới';
//                   } else if (value != _newPasswordController.text) {
//                     return 'Mật khẩu không khớp';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _changePassword,
//                 child: Text('Đổi mật khẩu'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu cũ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu mới'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  } else if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  } else if (value != _newPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Đổi mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        
        // Xác thực người dùng với mật khẩu cũ
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);
        
        // Nếu xác thực thành công, cập nhật mật khẩu mới
        await user.updatePassword(_newPasswordController.text);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mật khẩu đã được cập nhật thành công")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Có lỗi xảy ra: $e")),
        );
      }
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.backColor,
  //     appBar: AppBar(
  //       backgroundColor: AppColors.btnColor,
  //       iconTheme: IconThemeData(color: Colors.white),
  //       title: Text(
  //         "ĐỔI MẬT KHẨU",
  //         style: TextStyle(fontSize: 30, color: Colors.white),
  //       ),
  //     ),
  //     body: Center(
  //       child:Padding(
  //         padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(17.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: Colors.white, // Màu sắc của border
  //                   width: 1.0, // Độ dày của border
  //                 ),
  //                 borderRadius: BorderRadius.circular(20.0), // Góc bo tròn
  //               ),
  //               margin: EdgeInsets.only(top: 30),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.lock,size: 20,color: Colors.white,
  //                   ),
  //                   Text("Mật khẩu cũ",
  //                   style: TextStyle(fontSize: 20, color: Colors.white,),)
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(17.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: Colors.white, // Màu sắc của border
  //                   width: 1.0, // Độ dày của border
  //                 ),
  //                 borderRadius: BorderRadius.circular(20.0), // Góc bo tròn
  //               ),
  //               margin: EdgeInsets.only(top: 30),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.lock,size: 20,color: Colors.white,
  //                   ),
  //                   Text("Mật khẩu mới",
  //                   style: TextStyle(fontSize: 20, color: Colors.white,),)
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(17.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: Colors.white, // Màu sắc của border
  //                   width: 1.0, // Độ dày của border
  //                 ),
  //                 borderRadius: BorderRadius.circular(20.0), // Góc bo tròn
  //               ),
  //               margin: EdgeInsets.only(top: 30),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.lock,size: 20,color: Colors.white,
  //                   ),
  //                   Text("Xác nhận mật khẩu mới",
  //                   style: TextStyle(fontSize: 20, color: Colors.white,),)
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround, // Căn giữa các phần tử
  //           crossAxisAlignment: CrossAxisAlignment.center, // Căn chỉnh các phần tử theo chiều dọc
  //           children:[
  //             Container(
  //               margin: EdgeInsets.only(top: 30),
  //               child: Row(
  //               children: [
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.btnColor,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8)),
  //                   ),
  //                   onPressed: () {
  //                     // Navigator.push(
  //                     //   context,
  //                     //   MaterialPageRoute(
  //                     //     builder: (context) => EditAccountScreen(
  //                     //         account: account, onSave: onSave)(),
  //                     //   ),
  //                     // );
  //                   },
  //                   child: Text('Cập nhật',style: TextStyle(fontSize: 20, color: Colors.white,),),
  //                 ),
  //               ],
  //             )),
  //           ],
  //         )
  //       ],
  //     ))),
  //   );
  // }
}