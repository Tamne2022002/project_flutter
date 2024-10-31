import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
   int CauHoi_ID;
   int ChuDe_ID;
   Timestamp createdDate;
   String NoiDung_CauHoi;
   int TrangThai;
    String TenChuDe;


  Question({
    required this.CauHoi_ID,
    required this.ChuDe_ID,
    required this.createdDate,
    required this.NoiDung_CauHoi,
    required this.TrangThai,
     this.TenChuDe = ""
  });

  // Phương thức từ Firestore
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      CauHoi_ID: data['CauHoi_ID'] ?? 0,
      ChuDe_ID: data['ChuDe_ID'] ?? 0,
      createdDate: (data['NgayTao']).toDate(),
      NoiDung_CauHoi: data['NoiDung'] ?? '',
      TrangThai: data['TrangThai'] ?? 1,
      TenChuDe: "",
    );
  }
}
