import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/admin/BoDe/ChiTietBoDe.dart';
import 'package:project_flutter/admin/BoDe/Sua_BoDe.dart';
import 'package:project_flutter/admin/BoDe/Them_BoDe_screen.dart';
import 'package:project_flutter/admin/BoDe/Them_ChiTietBoDe.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';

class BoDeScreen extends StatefulWidget {
  @override
  _BoDeScreenState createState() => _BoDeScreenState();
}

class _BoDeScreenState extends State<BoDeScreen> {
  List<BoDe> boDeList = [];
  List<Topic> chuDeList = [];
  final BoDeService boDeService = BoDeService();
  final TopicService topicService = TopicService();

  @override
  void initState() {
    super.initState();
    _loadBoDes();
    _loadChuDes();
  }

  Future<void> _loadBoDes() async {
    try {
      List<BoDe> loadedBoDes = await boDeService.loadBoDes();
      setState(() {
        boDeList = loadedBoDes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    }
  }

  Future<void> _loadChuDes() async {
    try {
      chuDeList = await topicService.loadTopics();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải chủ đề: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Danh sách Bộ đề", style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...boDeList.map((boDe) => _buildListItem(context, boDe)).toList(),
                   
                  ],
                ),
              ),
            ),
                     _buildAddButton(context),
          ],
        ),

      ),
    );
  }

  Widget _buildListItem(BuildContext context, BoDe boDe) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.btnColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        title: _buildBoDeInfo(boDe),
        trailing: _buildActionButtons(context, boDe),
      ),
    );
  }

  Column _buildBoDeInfo(BoDe boDe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bộ đề ${boDe.boDeId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text('Đề tài: ${boDe.tenChuDe}', style: TextStyle(fontSize: 16, color: Colors.white)),
        Text('Số lượng câu: ${boDe.soLuongCau}', style: TextStyle(fontSize: 16, color: Colors.white)),
        Text('Trạng thái: ${boDe.trangThai == 1 ? 'Hoạt động' : 'Không hoạt động'}', style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

Row _buildActionButtons(BuildContext context, BoDe boDe) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildIconButton(Icons.edit, Colors.white, () => _editItem(context, boDe)),
      _buildIconButton(Icons.add_circle_outline, Colors.white, () => _addChiTietItem(context, boDe)),
      _buildIconButton(Icons.delete, Colors.white, () => _deleteItem(context, boDe)),
      _buildIconButton(Icons.remove_red_eye, Colors.white, () => _viewChiTietBoDe(context, boDe)), // Nút icon mắt
    ],
  );
}


  IconButton _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon, color: color), onPressed: onPressed);
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => _addItem(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text("Thêm Bộ đề", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

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
            });
          },
        ),
      ),
    );
  }

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
              onPressed: () async {
                Navigator.pop(context); // Đóng hộp thoại
                try {
                  await boDeService.deleteBoDe(boDe.boDeId); // Gọi hàm xóa từ BoDeService
                  _loadBoDes(); // Tải lại danh sách bộ đề
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa Bộ đề ${boDe.boDeId}')));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Có lỗi xảy ra: $error')));
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
        builder: (context) => AddBoDeScreen(
          chuDeList: chuDeList,
          onSave: (newBoDe) {
            _loadBoDes(); // Tải lại danh sách bộ đề
          },
        ),
      ),
    );
  }

void _addChiTietItem(BuildContext context, BoDe boDe) {
  // Giả sử bạn đã có một hàm để lấy chủ đề ID từ BoDe
  int chuDeId = boDe.chuDeId; // Thay thế bằng cách lấy ID từ boDe

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddChiTietBoDeScreen(
        boDeId: boDe.boDeId, // ID bộ đề
        maxSoLuongCau: boDe.soLuongCau, // Số lượng câu hỏi tối đa (có thể thay đổi tùy nhu cầu)
        chuDeId: chuDeId, // ID của chủ đề
        onSave: (ChiTietBoDe chiTietBoDe) {
          // Logic để cập nhật danh sách chi tiết bộ đề sau khi lưu
          setState(() {

          });
        },
      ),
    ),
  );
}

void _viewChiTietBoDe(BuildContext context, BoDe boDe) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChiTietBoDeScreen(boDeId: boDe.boDeId), // Truyền boDeId
    ),
  );
}


}
