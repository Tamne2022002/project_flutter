import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_flutter/friends/timkiembanbe.dart';
import 'package:project_flutter/friends/chitiet_friend.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendScreen extends StatefulWidget {
  
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //  final List<Map<String, String>> friends = [
  //   {"name": "Nguyen Van A", "email": "vana@example.com", "phone": "0123456789"},
  //   {"name": "Le Thi B", "email": "lethi@example.com", "phone": "0987654321"},
  //   {"name": "Tran Van C", "email": "vanc@example.com", "phone": "0147852369"},
  // ];
  @override

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backColor,
          title: Text("Xóa bạn bè với người này".toUpperCase(),
          style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
          ),
           actions: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
                  TextButton(
                onPressed: () {
                  // Đóng dialog khi nhấn nút OK
                  Navigator.of(context).pop();
                },
                child: Text("Hủy"),
              ),
              TextButton(
                onPressed: () {
                  // Đóng dialog khi nhấn nút OK
                  //Navigator.of(context).pop();
                },
                child: Text("Xóa"),
              ),
            ],
            )
           ],
        );
      },
    );
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
        appBar: AppBar(
          backgroundColor: AppColors.btnColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "DANH SÁCH BẠN BÈ",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF461A42),
                        borderRadius: BorderRadius.circular(20)),
                        child: GestureDetector(
                          onTap: () {
                            // Chuyển đến màn hình tìm kiếm khi nhấn vào khung tìm kiếm
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SearchUserScreen()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  "Tìm kiếm...",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                    // child: TextField(
                    //   textAlign: TextAlign.center,
                    //   decoration: InputDecoration(
                    //     hintText: "Tìm kiếm",
                    //     hintStyle: TextStyle(color: Colors.white),
                    //     prefixIcon: Icon(
                    //       Icons.search,
                    //       color: Colors.white,
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   style: TextStyle(color: Colors.white),
                    //   onTap: () {
                    //     // Chuyển đến màn hình tìm kiếm khi nhấn vào khung tìm kiếm
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => SearchUserScreen()),
                    //     );
                    //   },
                    // ),
                  ),


                  // ListView.builder(
                  //   itemCount: friends.length,
                  //   itemBuilder: (context, index) {
                  //     final friend = friends[index];
                  //     return ListTile(
                  //       title: Text(friend['name'] ?? ''),
                  //       subtitle: Text(friend['email'] ?? ''),
                  //       onTap: () {
                  //         // Chuyển đến màn hình chi tiết của bạn bè khi nhấn vào
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => FriendDetailScreen(
                  //               friendName: friend['name'] ?? '',
                  //               friendEmail: friend['email'] ?? '',
                  //               friendPhone: friend['phone'] ?? '',
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),  
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0), 
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(color: AppColors.btnColor,borderRadius: BorderRadius.circular(20.0), ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            'phuchau ne',
                            style: TextStyle(
                              color: Colors.white,  // Màu chữ
                              fontSize: 24.0,  // Kích thước chữ
                              fontWeight:FontWeight.w400,  // Độ đậm của chữ
                              )
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel, size: 25, color: Colors.white,),
                              onPressed: () {
                                _showDialog(context);
                              },
                            ),
                            
                          ],
                        ),
                        
                      ),
                    ],
                  ),
                    ],
              ),
          ),
        ),
      );
  }

   Future<void> removeFriend(String userId, String friendId) async {
    try {
      // Xóa bạn bè khỏi danh sách của userId
      await FirebaseFirestore.instance
          .collection('NguoiDung')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .delete();

      // Xóa userId khỏi danh sách bạn bè của friendId
      await FirebaseFirestore.instance
          .collection('NguoiDung')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .delete();

      print("Đã xóa bạn bè thành công.");
    } catch (e) {
      print("Có lỗi xảy ra khi xóa bạn bè: $e");
    }
  }

  Future<List<Account>> loadAccounts() async {
    try {
      final snapshot = await _firestore.collection('NguoiDung').get();
      List<Account> loadedAccounts = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>; // Ép kiểu rõ ràng
        loadedAccounts.add(Account(
            name: data['hoTen'] ?? 'Không có tên',
            email: data['email'] ?? 'Không có email',
            phone: data['sdt'] ?? 'Không có số điện thoại',
            password: '', // Mật khẩu không nên lưu trong DB
            role: data['phanQuyen_ID'] ?? 0,
            xp: data['kinhNghiem'] ?? 0,
            id: data['nguoiDung_ID'] ?? 1 // Đảm bảo ID được khởi tạo đúng
            ));
      }

      return loadedAccounts;
    } catch (e) {
      log("Error loading accounts: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }
}
