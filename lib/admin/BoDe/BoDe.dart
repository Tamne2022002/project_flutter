import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/Sua_BoDe.dart';
import 'package:project_flutter/admin/BoDe/Them_BoDe_screen.dart';
import 'package:project_flutter/admin/BoDe/Them_ChiTietBoDe.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';

class BoDeScreen extends StatefulWidget {
  @override
  _BoDeScreenState createState() => _BoDeScreenState();
}

class _BoDeScreenState extends State<BoDeScreen> {
  List<BoDe> boDeList = []; // Danh sách các bộ đề
  List<String> chuDeList = ['Đề tài 1', 'Đề tài 2', 'Đề tài 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text(
          "Danh sách Bộ đề",
          style: TextStyle(fontSize: 22,color: Colors.white),
        ),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (var boDe in boDeList) _buildListItem(context, boDe),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  // Hiển thị bộ đề trong danh sách
  // Hiển thị bộ đề trong danh sách
  Widget _buildListItem(BuildContext context, BoDe boDe) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.btnColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bộ đề ${boDe.boDeId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Đề tài: ${chuDeList[boDe.chuDeId - 1]}', // Giả sử chuDeId bắt đầu từ 1
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Số lượng câu: ${boDe.soLuongCau}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Trạng thái: ${boDe.trangThai == 1 ? 'Hoạt động' : 'Không hoạt động'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nút chỉnh sửa bộ đề
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editItem(context, boDe),
            ),
            // Nút thêm chi tiết bộ đề
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () => _addChiTietItem(context, boDe),
            ),
            // Nút xóa bộ đề
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteItem(context, boDe),
            ),
          ],
        ),
      ),
    );
  }

  // Nút thêm bộ đề
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
          "Thêm Bộ đề",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Chỉnh sửa bộ đề
  void _editItem(BuildContext context, BoDe boDe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBoDeScreen(
          boDe: boDe,
          chuDeList: chuDeList,
          onSave: (updatedBoDe) {
            setState(() {
              boDe.soLuongCau = updatedBoDe.soLuongCau;
              boDe.chuDeId = updatedBoDe.chuDeId;
              boDe.trangThai = updatedBoDe.trangThai;
              boDe.updateAt = updatedBoDe.updateAt;
            });
          },
        ),
      ),
    );
  }

  // Xóa bộ đề
  void _deleteItem(BuildContext context, BoDe boDe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa Bộ đề ${boDe.boDeId}?'),
          content: Text('Bạn có chắc chắn muốn xóa Bộ đề này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy', style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  boDeList.remove(boDe);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa Bộ đề ${boDe.boDeId}')),
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

  // Thêm bộ đề mới
  void _addItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBoDeScreen(
          chuDeList: chuDeList,
          onSave: (newBoDe) {
            setState(() {
              boDeList.add(newBoDe);
            });
          },
        ),
      ),
    );
  }

  // Thêm chi tiết bộ đề
  void _addChiTietItem(BuildContext context, BoDe boDe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChiTietBoDeScreen(
          boDeId: boDe.boDeId,
          onSave: (newChiTiet) {
            setState(() {
              // Thêm chi tiết bộ đề vào danh sách chi tiết bộ đề của boDe
              boDe.chiTietBoDeList.add(newChiTiet);
            });
          },
          maxSoLuongCau: boDe.soLuongCau,
        ),
      ),
    );
  }
}
