import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/topic.dart';

class TopicService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Topic>> loadTopics() async {
    final snapshot = await firestore.collection('ChuDe').get();
    List<Topic> loadedTopics = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      loadedTopics.add(Topic(
        TenChuDe: data['TenChuDe'] ?? 'Không có tên',
        SLCauHoi: 0,
        ChuDe_ID: data['ChuDe_ID'] ?? 0,
      ));
    }

    return loadedTopics;
  }

  Future<void> addTopic(String title, int chuDeID) async {
    await firestore.collection('ChuDe').add({
      'TenChuDe': title,
      'ChuDe_ID': chuDeID,
      'TrangThai': 1,
      'NgayTao': Timestamp.now(),
    });
  }

  Future<void> updateTopic(int chuDeID, String title) async {
    // Tìm kiếm tài liệu bằng ChuDe_ID
    var querySnapshot = await firestore
        .collection('ChuDe')
        .where('ChuDe_ID', isEqualTo: chuDeID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Cập nhật tài liệu
      await querySnapshot.docs.first.reference.update({
        'TenChuDe': title,
      });
    } else {
      throw Exception('Không tìm thấy chủ đề với ChuDe_ID: $chuDeID');
    }
  }

  Future<void> deleteTopic(int chuDeID) async {
    // Tìm kiếm tài liệu bằng ChuDe_ID
    var querySnapshot = await firestore
        .collection('ChuDe')
        .where('ChuDe_ID', isEqualTo: chuDeID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Xóa tài liệu
      await querySnapshot.docs.first.reference.delete();

      // Cập nhật lại danh sách bộ đề sau khi xóa chủ đề
      await updateBoDeAfterTopicDeletion(chuDeID);
      await updateCauHoiDapAnAfterTopicDeletion(chuDeID);
    } else {
      throw Exception('Không tìm thấy chủ đề với ChuDe_ID: $chuDeID');
    }
  }
  Future<void> updateCauHoiDapAnAfterTopicDeletion(int chuDeID) async {
  // Tải danh sách câu hỏi hiện tại
  var allQuestions = await firestore.collection('CauHoi').get();

  // Lọc ra các câu hỏi không còn chủ đề hợp lệ
  var invalidQuestions = allQuestions.docs.where((question) {
    return question['ChuDe_ID'] == chuDeID;
  }).toList();

  // Xóa các câu hỏi không hợp lệ
  for (var question in invalidQuestions) {
    await question.reference.delete();
  }

  // Tải danh sách đáp án hiện tại
  var allAnswers = await firestore.collection('DapAn').get();

  // Lọc ra các đáp án không còn câu hỏi hợp lệ
  var invalidAnswers = allAnswers.docs.where((answer) {
    // Kiểm tra xem đáp án có thuộc về một câu hỏi đã bị xóa hay không
    return !invalidQuestions.any((q) => q.id == answer['CauHoi_ID']);
  }).toList();

  // Xóa các đáp án không hợp lệ
  for (var answer in invalidAnswers) {
    await answer.reference.delete();
  }
}


// // Hàm để cập nhật danh sách bộ đề
//   Future<void> updateBoDeAfterTopicDeletion(int chuDeID) async {
//     // Tải danh sách bộ đề hiện tại
//     var allBoDe = await firestore.collection('BoDe').get();

//     // Lọc ra các bộ đề không còn chủ đề hợp lệ
//     var invalidBoDe = allBoDe.docs.where((boDe) {
//       return boDe['ChuDe_ID'] == chuDeID;
//     }).toList();

//     // Xóa các bộ đề không hợp lệ
//     for (var boDe in invalidBoDe) {
//       await boDe.reference.delete();
//     }
//   }
Future<void> updateBoDeAfterTopicDeletion(int chuDeID) async {
  // Tải danh sách bộ đề hiện tại
  var allBoDe = await firestore.collection('BoDe').get();

  // Lọc ra các bộ đề không còn chủ đề hợp lệ
  var invalidBoDe = allBoDe.docs.where((boDe) {
    return boDe['ChuDe_ID'] == chuDeID;
  }).toList();

  // Xóa các bộ đề không hợp lệ và chi tiết bộ đề tương ứng
  for (var boDe in invalidBoDe) {
    int boDeID = boDe['BoDe_ID']; // Lấy BoDe_ID từ tài liệu

    // Xóa chi tiết bộ đề có cùng BoDe_ID
    await deleteChiTietBoDeByBoDeID(boDeID);

    // Xóa bộ đề không hợp lệ
    await boDe.reference.delete();
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

  

  // Lấy tên chủ đề theo ChuDe_ID
  Future<String> getTenChuDe(int chuDeId) async {
    var querySnapshot = await firestore
        .collection('ChuDe')
        .where('ChuDe_ID', isEqualTo: chuDeId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()?['TenChuDe'] ?? 'Không có tên';
    } else {
      throw Exception('Không tìm thấy chủ đề với ID: $chuDeId');
    }
  }
  // Hàm để lấy ID lớn nhất của chủ đề
  Future<int> getMaxTopicId() async {
    final snapshot = await firestore.collection('ChuDe').get();
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int currentId = doc['ChuDe_ID'] ?? 0; // Lấy giá trị ChuDe_ID
      if (currentId > maxId) {
        maxId = currentId; // Cập nhật maxId nếu currentId lớn hơn
      }
    }

    return maxId; // Trả về ID lớn nhất
  }
}
