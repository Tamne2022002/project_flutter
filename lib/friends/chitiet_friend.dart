import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/admin/TaiKhoan/SuaTK_Screen.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';

class FriendDetailScreen extends StatefulWidget {

  final String friendName;
  final String friendEmail;
  final String friendPhone;

  // Nhận dữ liệu bạn bè từ màn hình trước
  FriendDetailScreen({
    required this.friendName,
    required this.friendEmail,
    required this.friendPhone,
  });
  //const FriendDetailScreen({super.key});

  @override
  State<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends State<FriendDetailScreen> {
  
 @override
  // void _showUnfriend(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: AppColors.backColor,
  //         title: Text("Bạn chắc chắn chứ",
  //         style: TextStyle(
  //                     fontSize: 36,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   textAlign: TextAlign.center,
  //         ),
  //          actions: [
  //           Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children:[
  //                 TextButton(
  //               onPressed: () {
  //                 // Đóng dialog khi nhấn nút OK
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("Hủy"),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 // Đóng dialog khi nhấn nút OK
  //                 //Navigator.of(context).pop();
  //               },
  //               child: Text("Xóa"),
  //             ),
  //           ],
  //           )
  //          ],
  //       );
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "BẠN BÈ 1",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "BẠN BÈ 1".toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.white,
                            ),
                            Text(
                              "Email: ngphuchau1912@gmail.com",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.white,
                            ),
                            Text(
                              "Sđt: 0928149081",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              Text(
                                "Điểm kinh nghiệm:",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                " 20",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              Text(
                                "Bạn bè:",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(" 5",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:Color(0xFF998DA6),
                                title: Text('Thông báo'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Đóng dialog
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'HỦY KẾT BẠN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ]
                    )
                ],
              )
            )
          ),
    );
  }
}
