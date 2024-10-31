import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/dapan.dart'; // Đảm bảo bạn đã import DapAn class

class DapAnService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm một đáp án mới
  Future<void> addAnswer(DapAn dapAn) async {
    await _firestore.collection('DapAn').add({
      'CauHoi_ID': dapAn.CauHoi_ID,
      'ND_DapAn': dapAn.ND_DapAn,
      'DungSai': dapAn.DungSai,
      'Diem': dapAn.Diem,
      'TrangThai': dapAn.TrangThai,
    });
  }

  // Lấy danh sách đáp án theo ID câu hỏi
  Future<List<DapAn>> getAnswersByQuestionId(int cauHoiId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('DapAn')
        .where('CauHoi_ID', isEqualTo: cauHoiId)
        .get();

    return snapshot.docs.map((doc) {
      return DapAn(
        CauHoi_ID: doc['CauHoi_ID'],
        ND_DapAn: doc['ND_DapAn'],
        DungSai: doc['DungSai'],
        Diem: doc['Diem'] ?? 0, // Giá trị mặc định
        TrangThai: doc['TrangThai'] ?? 1, // Giá trị mặc định
      );
    }).toList();
  }

  // Cập nhật một đáp án
  Future<void> updateAnswer(DapAn dapAn) async {
    await _firestore
        .collection('DapAn')
        .doc(dapAn.CauHoi_ID.toString()) // Thay đổi cách lấy ID nếu cần
        .update({
      'ND_DapAn': dapAn.ND_DapAn,
      'DungSai': dapAn.DungSai,
      'Diem': dapAn.Diem,
      'TrangThai': dapAn.TrangThai,
    });
  }

  // Xóa một đáp án
  Future<void> deleteAnswer(String answerId) async {
    await _firestore.collection('DapAn').doc(answerId).delete();
  }
}
