import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_flutter/friends/timkiembanbe.dart';
import 'package:project_flutter/friends/chitiet_friend.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/friends/source_friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class FriendsListScreen extends StatefulWidget {

//   const FriendsListScreen({super.key});

//   @override
//   State<FriendsListScreen> createState() => _FriendsListScreenState();
// }

// class _FriendsListScreenState extends State<FriendsListScreen> {
//   // final String nguoiDung_ID;

//   AuthFriend _authFriend = AuthFriend();
//   //FriendsListScreen({required this.nguoiDung_ID});
//  @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       backgroundColor: AppColors.backColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.btnColor,
//           iconTheme: IconThemeData(color: Colors.white),
//           title: Text(
//             "DANH SÁCH BẠN BÈ",
//             style: TextStyle(fontSize: 30, color: Colors.white),
//           ),
//         ),
//         body: FutureBuilder<List?>(
//         future: _authFriend.getFriendsList(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('You have no friends yet.'));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   String friend_ID = snapshot.data![index];
//                   return ListTile(
//                     title: Text(friend_ID), // Có thể thay bằng tên người bạn
//                   );
//                 },
//               );
//             }
//           },
//       ));
//   }
// }

class FriendScreen extends StatefulWidget {
  
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  AuthFriend _authFriend = AuthFriend();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  void initState() {
    super.initState();
  }
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
                child: Text("Hủy",
                style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),),
              ),
              TextButton(
                onPressed: () {
                  // Đóng dialog khi nhấn nút OK
                  //Navigator.of(context).pop();
                },
                child: Text("Xóa",
                style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),),
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
}
