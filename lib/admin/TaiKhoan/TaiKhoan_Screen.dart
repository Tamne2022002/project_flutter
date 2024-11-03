import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/authen/service.dart'; // Import AuthService

import 'ThemTK_Screen.dart';
import 'SuaTK_Screen.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> accounts = [];
  List<Account> filteredAccounts = [];
  final AuthService _authService = AuthService();
  int? selectedRole; // Biến để lưu phân quyền đã chọn

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final loadedAccounts = await _authService.loadAccounts();
      setState(() {
        accounts = loadedAccounts;
        filteredAccounts = accounts; // Khởi tạo danh sách đã lọc
      });
    } catch (e) {
      print("Error loading accounts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách tài khoản')),
      );
    }
  }

  void _filterAccounts() {
    if (selectedRole == null) {
      filteredAccounts = accounts; // Nếu không chọn, hiển thị tất cả
    } else {
      filteredAccounts =
          accounts.where((account) => account.role == selectedRole).toList();
    }
    setState(() {}); // Cập nhật giao diện
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Danh sách Tài khoản",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown để chọn phân quyền
            DropdownButton<int>(
              dropdownColor: AppColors.btnColor,
              hint: Text(
                'Chọn phân quyền',
                style: TextStyle(color: Colors.white),
              ),
              value: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                  _filterAccounts(); // Gọi phương thức lọc
                });
              },
              items: [
                DropdownMenuItem(
                    value: 0,
                    child: Text('Người Dùng',
                        style: TextStyle(color: Colors.white))),
                DropdownMenuItem(
                    value: 1,
                    child:
                        Text('Admin', style: TextStyle(color: Colors.white))),
              ],
            ),
            SizedBox(height: 16), // Khoảng cách
            Expanded(
              child: filteredAccounts.isEmpty
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Hiển thị loading nếu chưa có dữ liệu
                  : ListView(
                      children: [
                        for (var account in filteredAccounts)
                          _buildListItem(context, account),
                      ],
                    ),
            ),
            // Nút thêm tài khoản
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Account account) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
          'Email: ${account.email}\nSĐT: ${account.phone}\nXP: ${account.xp}\nQuyền hạn: ${account.role}\nID: ${account.id}',
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

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addItem(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Thêm Tài khoản",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

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
              onPressed: () async {
                // Gọi hàm xóa tài khoản từ AuthService
                bool success = await _authService.deleteAccount(account.id);
                if (success) {
                  setState(() {
                    accounts.remove(account);
                    _filterAccounts(); // Cập nhật danh sách đã lọc
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa ${account.name}')),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa thất bại!')),
                  );
                }
              },
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _addItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountScreen(),
      ),
    ).then((newAccount) {
      if (newAccount != null) {
        setState(() {
          accounts.add(newAccount);
          _filterAccounts(); // Cập nhật danh sách đã lọc
        });
      }
    });
  }
}
