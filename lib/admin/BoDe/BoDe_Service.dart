import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/model/bode.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/question.dart';

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

Future<List<int>> getSelectedQuestionIds(int boDeId) async {
  try {
    // Lấy các ChiTietBoDe đã có từ Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ChiTietBoDe')
        .where('BoDe_ID', isEqualTo: boDeId)
        .get();

    List<int> selectedQuestionIds = snapshot.docs.map((doc) {
      return doc['CauHoi_ID'] as int;
    }).toList();

    return selectedQuestionIds;
  } catch (e) {
    print("Error fetching selected questions: $e");
    return [];
  }
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
    // Tìm kiếm tài liệu bằng BoDe_ID
    var querySnapshot = await firestore
        .collection('BoDe')
        .where('BoDe_ID', isEqualTo: boDeId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Xóa tài liệu
      await querySnapshot.docs.first.reference.delete();
      // Xóa các bộ đề không hợp lệ và chi tiết bộ đề tương ứng

      // Xóa chi tiết bộ đề có cùng BoDe_ID
      await deleteChiTietBoDeByBoDeID(boDeId);

      // Cập nhật lại danh sách câu hỏi hoặc bất kỳ hành động nào cần thiết sau khi xóa bộ đề
      await updateQuestionsAfterBoDeDeletion(boDeId);
    } else {
      throw Exception('Không tìm thấy bộ đề với BoDe_ID: $boDeId');
    }
  }

  // Hàm xóa chi tiết bộ đề theo BoDe_ID
  Future<void> deleteChiTietBoDeByBoDeID(int boDeID) async {
    var querySnapshot = await firestore
        .collection('ChiTietBoDe')
        .where('BoDe_ID', isEqualTo: boDeID)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateQuestionsAfterBoDeDeletion(int boDeId) async {
    // Tải danh sách bộ đề hiện tại
    var allBoDe = await firestore.collection('BoDe').get();

    // Lọc ra các bộ đề không còn chủ đề hợp lệ
    var invalidBoDe = allBoDe.docs.where((boDe) {
      return boDe['ChuDe_ID'] == boDeId;
    }).toList();

    // Xóa các bộ đề không hợp lệ
    for (var boDe in invalidBoDe) {
      await boDe.reference.delete();
    }
  }

  // Hàm để lấy ID lớn nhất của bộ đề
  Future<int> getMaxBoDeId() async {
    final snapshot = await firestore.collection('BoDe').get();
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int currentId = doc['BoDe_ID'] ?? 0; // Lấy giá trị BoDe_ID
      if (currentId > maxId) {
        maxId = currentId; // Cập nhật maxId nếu currentId lớn hơn
      }
    }

    return maxId; // Trả về ID lớn nhất
  }

  Future<int> getCTMaxBoDeId() async {
    final snapshot = await firestore.collection('ChiTietBoDe').get();
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int currentId = doc['ChiTietBoDe_ID'] ?? 0; // Lấy giá trị CTBoDe_ID
      if (currentId > maxId) {
        maxId = currentId; // Cập nhật maxId nếu currentId lớn hơn
      }
    }

    return maxId; // Trả về ID lớn nhất
  }

  // Tải danh sách chi tiết bộ đề theo ID bộ đề
  Future<List<ChiTietBoDe>> loadChiTietBoDe(int boDeId) async {
    final snapshot = await firestore
        .collection('ChiTietBoDe')
        .where('BoDe_ID', isEqualTo: boDeId)
        .get();

    List<ChiTietBoDe> chiTietList = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var chiTietBoDe = ChiTietBoDe(
        chiTietBoDeId: data['ChiTietBoDe_ID'] ?? 0,
        cauHoiId: data['CauHoi_ID'] ?? 0,
        boDeId: data['BoDe_ID'] ?? 0,
        createAt: (data['create_at'] as Timestamp).toDate(),
        updateAt: (data['update_at'] as Timestamp).toDate(),
        trangThai: data['TrangThai'] ?? 1,
      );

      chiTietList.add(chiTietBoDe);
    }

    return chiTietList;
  }

  // Thêm chi tiết bộ đề
  Future<void> addChiTietBoDe(ChiTietBoDe chiTietBoDe) async {
    await firestore.collection('ChiTietBoDe').add({
      'ChiTietBoDe_ID': chiTietBoDe.chiTietBoDeId,
      'CauHoi_ID': chiTietBoDe.cauHoiId,
      'BoDe_ID': chiTietBoDe.boDeId,
      'create_at': Timestamp.fromDate(chiTietBoDe.createAt),
      'update_at': Timestamp.fromDate(chiTietBoDe.updateAt),
      'TrangThai': chiTietBoDe.trangThai,
    });
  }

  Future<int> getChiTietBoDeCount(int boDeId) async {
    final snapshot = await firestore
        .collection('ChiTietBoDe')
        .where('BoDe_ID', isEqualTo: boDeId)
        .get();
    return snapshot.docs.length;
  }

  Future<Question?> getCauHoiById(int cauHoiId) async {
    var querySnapshot = await firestore
        .collection('CauHoi')
        .where('CauHoi_ID', isEqualTo: cauHoiId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      return Question(
        CauHoi_ID: data['CauHoi_ID'] ?? 0,
        NoiDung_CauHoi: data['NoiDung'] ?? '', // Thay thế bằng trường tương ứng
        ChuDe_ID: data['ChuDe_ID'],
        TrangThai: data['TrangThai'],
        NgayTao: (data['NgayTao'] as Timestamp).toDate(),
      );
    }
    return null;
  }
}
