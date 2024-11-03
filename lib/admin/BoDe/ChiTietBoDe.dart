import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/admin/BoDe/BoDe_Service.dart';
import 'package:project_flutter/model/question.dart';

class ChiTietBoDeScreen extends StatelessWidget {
  final int boDeId;

  ChiTietBoDeScreen({required this.boDeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text("Danh sách Chi tiết Bộ đề", style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColors.btnColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ChiTietBoDe>>(
        future: BoDeService().loadChiTietBoDe(boDeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<ChiTietBoDe> chiTietList = snapshot.data!;
            return FutureBuilder<List<Question?>>(
              future: Future.wait(
                chiTietList.map((chiTiet) => BoDeService().getCauHoiById(chiTiet.cauHoiId)),
              ),
              builder: (context, cauHoiSnapshot) {
                if (cauHoiSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (cauHoiSnapshot.hasError) {
                  return Center(child: Text('Lỗi: ${cauHoiSnapshot.error}'));
                } else if (cauHoiSnapshot.hasData) {
                  List<Question?> cauHoiList = cauHoiSnapshot.data!;
                  return ListView.builder(
                    itemCount: cauHoiList.length,
                    itemBuilder: (context, index) {
                      final cauHoi = cauHoiList[index];
                      return ListTile(
                        leading: Text("Câu hỏi :",style: TextStyle(fontSize: 18, color: Colors.white)),
                        title: Text(cauHoi?.NoiDung_CauHoi ?? 'Nội dung không có', style: TextStyle(fontSize: 20, color: Colors.white)),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Không có dữ liệu'));
                }
              },
            );
          } else {
            return Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }
}

