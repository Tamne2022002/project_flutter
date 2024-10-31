
import 'package:project_flutter/model/chitietbode.dart';

class BoDe {
  int boDeId;
  int chuDeId;
  int soLuongCau;
  DateTime createAt;
  DateTime updateAt;
  int trangThai;
  String tenChuDe;
  
  // Danh sách các chi tiết bộ đề
  List<ChiTietBoDe> chiTietBoDeList;

  BoDe({
    required this.boDeId,
    required this.chuDeId,
    required this.soLuongCau,
    required this.createAt,
    required this.updateAt,
    required this.trangThai,
      this.tenChuDe = "",
    this.chiTietBoDeList = const [], // Mặc định là danh sách rỗng
  });
}
