import 'package:flutter/material.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/admin/BoDe/Sua_BoDe.dart';
import 'package:project_flutter/admin/BoDe/Them_BoDe_screen.dart';
import 'package:project_flutter/admin/BoDe/Them_ChiTietBoDe.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';

class BoDeScreen extends StatefulWidget {
  @override
  _BoDeScreenState createState() => _BoDeScreenState();
}

class _BoDeScreenState extends State<BoDeScreen> {
  List<BoDe> boDeList = [];
  List<Topic> chuDeList = []; // Thay đổi kiểu dữ liệu để lưu danh sách chủ đề
  final BoDeService boDeService = BoDeService();
  final TopicService topicService = TopicService();

  @override
  void initState() {
    super.initState();
    _loadBoDes(); // Gọi hàm để tải danh sách bộ đề
    _loadChuDes(); // Gọi hàm để tải danh sách chủ đề
  }

  // Tải danh sách bộ đề từ Firestore
  Future<void> _loadBoDes() async {
    try {
      List<BoDe> loadedBoDes = await boDeService.loadBoDes();
      setState(() {
        boDeList = loadedBoDes; // Cập nhật danh sách bộ đề
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    }
  }

  // Tải danh sách chủ đề từ Firestore
  Future<void> _loadChuDes() async {
    try {
      chuDeList = await topicService.loadTopics(); // Tải danh sách chủ đề
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải chủ đề: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Danh sách Bộ đề",
            style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...boDeList.map((boDe) => _buildListItem(context, boDe)).toList(),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  // Hiển thị bộ đề trong danh sách
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

  // Thông tin bộ đề
  Column _buildBoDeInfo(BoDe boDe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bộ đề ${boDe.boDeId}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text('Đề tài: ${boDe.tenChuDe}', // Sử dụng tenChuDe từ boDe
            style: TextStyle(fontSize: 16, color: Colors.white)),
        Text('Số lượng câu: ${boDe.soLuongCau}',
            style: TextStyle(fontSize: 16, color: Colors.white)),
        Text(
            'Trạng thái: ${boDe.trangThai == 1 ? 'Hoạt động' : 'Không hoạt động'}',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  // Nút hành động (Chỉnh sửa, thêm chi tiết, xóa)
  Row _buildActionButtons(BuildContext context, BoDe boDe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
            Icons.edit, Colors.white, () => _editItem(context, boDe)),
        _buildIconButton(Icons.add_circle_outline, Colors.white,
            () => _addChiTietItem(context, boDe)),
        _buildIconButton(
            Icons.delete, Colors.white, () => _deleteItem(context, boDe)),
      ],
    );
  }

  // Tạo nút IconButton
  IconButton _buildIconButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon, color: color), onPressed: onPressed);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text("Thêm Bộ đề",
            style: TextStyle(fontSize: 18, color: Colors.white)),
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
          chuDeList: chuDeList, // Sử dụng danh sách chủ đề tải từ Firestore
          onSave: (updatedBoDe) {
            setState(() {
              boDe.soLuongCau = updatedBoDe.soLuongCau;
              boDe.chuDeId = updatedBoDe.chuDeId;
              boDe.trangThai = updatedBoDe.trangThai;
              _loadBoDes();
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
                    SnackBar(content: Text('Đã xóa Bộ đề ${boDe.boDeId}')));
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
          chuDeList: chuDeList, // Sử dụng danh sách chủ đề tải từ Firestore
          onSave: (newBoDe) {
            // Gọi lại để tải danh sách bộ đề và danh sách chủ đề
            _loadBoDes();
            _loadChuDes(); // Tải lại danh sách chủ đề
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
              boDe.chiTietBoDeList.add(newChiTiet);
            });
          },
          maxSoLuongCau: boDe.soLuongCau,
        ),
      ),
    );
  }
}
