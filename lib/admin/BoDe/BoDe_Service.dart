import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/model/bode.dart';

class BoDeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TopicService topicService = TopicService();

  // Tải danh sách bộ đề
  Future<List<BoDe>> loadBoDes() async {
    final snapshot = await firestore.collection('BoDe').get();
    List<BoDe> loadedBoDes = [];

    List<Future<void>> futures = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var boDe = BoDe(
        boDeId: data['BoDe_ID'] ?? 0,
        chuDeId: data['ChuDe_ID'] ?? 0,
        soLuongCau: data['SoLuongCau'] ?? 0,
        createAt: (data['create_at'] as Timestamp).toDate(),
        updateAt: (data['update_at'] as Timestamp).toDate(),
        trangThai: data['TrangThai'] ?? 1,
        tenChuDe: '',
      );

      futures.add(
        topicService.getTenChuDe(boDe.chuDeId).then((tenChuDe) {
          boDe.tenChuDe = tenChuDe;
        }),
      );

      loadedBoDes.add(boDe);
    }

    await Future.wait(futures);

    return loadedBoDes;
  }

  // Thêm bộ đề mới
  Future<void> addBoDe(BoDe boDe) async {
    await firestore.collection('BoDe').add({
      'BoDe_ID': boDe.boDeId,
      'ChuDe_ID': boDe.chuDeId,
      'SoLuongCau': boDe.soLuongCau,
      'create_at': Timestamp.fromDate(boDe.createAt),
      'update_at': Timestamp.fromDate(boDe.updateAt),
      'TrangThai': boDe.trangThai,
    });
  }

  Future<void> updateBoDe(BoDe boDe) async {
    // Tìm tài liệu bằng ID
    var querySnapshot = await firestore
        .collection('BoDe')
        .where('BoDe_ID', isEqualTo: boDe.boDeId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Cập nhật tài liệu nếu tồn tại
      await querySnapshot.docs.first.reference.update({
        'ChuDe_ID': boDe.chuDeId,
        'SoLuongCau': boDe.soLuongCau,
        'update_at': Timestamp.fromDate(DateTime.now()), // Cập nhật thời gian
        'TrangThai': boDe.trangThai,
      });
    } else {
      throw Exception('Không tìm thấy bộ đề với ID: ${boDe.boDeId}');
    }
  }

  // Xóa bộ đề
  Future<void> deleteBoDe(int boDeId) async {
    await firestore.collection('BoDe').doc(boDeId.toString()).delete();
  }
}
