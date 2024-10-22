import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';

import 'ThemTK_Screen.dart';
import 'SuaTK_Screen.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> accounts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
            iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Danh sách Tài khoản",
          style: TextStyle(fontSize: 22,color: Colors.white ),
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Hiển thị danh sách tài khoản
            for (var account in accounts) _buildListItem(context, account),
            // Nút thêm tài khoản
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  // Hiển thị thông tin tài khoản trong danh sách
  Widget _buildListItem(BuildContext context, Account account) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bo góc Card
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      color: AppColors.btnColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Text(
          account.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Email: ${account.email}\nSĐT: ${account.phone}\nXP: ${account.xp}\nQuyền hạn: ${account.role}',
          style: TextStyle(color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editItem(context, account),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteItem(context, account),
            ),
          ],
        ),
      ),
    );
  }

  // Nút thêm tài khoản mới
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addItem(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor, // Màu nền button
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bo góc button
          ),
        ),
        child: Text(
          "Thêm Tài khoản",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Chỉnh sửa tài khoản
  void _editItem(BuildContext context, Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(
          account: account,
          onSave: (updatedAccount) {
            setState(() {
              account.name = updatedAccount.name;
              account.email = updatedAccount.email;
              account.phone = updatedAccount.phone;
              account.password = updatedAccount.password;
              account.role = updatedAccount.role;
              account.xp = updatedAccount.xp;
            });
          },
        ),
      ),
    );
  }

  // Xóa tài khoản
  void _deleteItem(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa ${account.name}?'),
          content: Text('Bạn có chắc chắn muốn xóa tài khoản này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy', style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  accounts.remove(account);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa ${account.name}')),
                );
              },
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  // Thêm tài khoản mới
  void _addItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountScreen(
          onSave: (newAccount) {
            setState(() {
              accounts.add(newAccount);
            });
          },
        ),
      ),
    );
  }
}
