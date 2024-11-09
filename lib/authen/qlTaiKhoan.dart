import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_flutter/authen/SuaTKScreen.dart';
import 'package:project_flutter/authen/doimatkhau.dart';
import 'package:project_flutter/authen/service.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/qlTaiKhoan.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AuthService _authService = AuthService();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
          backgroundColor: AppColors.btnColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "QUẢN LÝ THÔNG TIN",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        body: FutureBuilder<Account?>(
            future: _authService.getUserDocumentByUid(),
            builder: (context, snapshot) {
              Account? info = snapshot.data;
              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${info?.name}".toUpperCase(),
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
                                      "Email: ${info?.email}",
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
                                      "Sđt: ${info?.phone}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
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
                                        " ${info?.xp}",
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
                            mainAxisAlignment: MainAxisAlignment
                                .spaceAround, // Căn giữa các phần tử
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Căn chỉnh các phần tử theo chiều dọc
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.btnColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SuaTaikhoanScreen(
                                                account: info ?? null,
                                                onSave: (updatedAccount) {
                                                  setState(() {
                                                    info?.id = updatedAccount.id;
                                                    info?.name =
                                                        updatedAccount.name;
                                                    info?.phone =
                                                        updatedAccount.phone;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Sửa thông tin',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.btnColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePasswordScreen(
                                                account: info ?? null,
                                                onSave: (updatedAccount) {
                                                  setState(() {
                                                    info?.id = updatedAccount.id;
                                                    info?.password =
                                                        updatedAccount.password;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Đổi mật khẩu',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          )
                        ],
                      )
                    )
                  );
            }
          )
        );
  }
}