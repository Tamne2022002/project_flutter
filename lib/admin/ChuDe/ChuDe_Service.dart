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
    var querySnapshot = await firestore.collection('ChuDe').where('ChuDe_ID', isEqualTo: chuDeID).get();
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
    var querySnapshot = await firestore.collection('ChuDe').where('ChuDe_ID', isEqualTo: chuDeID).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Xóa tài liệu
      await querySnapshot.docs.first.reference.delete();
    } else {
      throw Exception('Không tìm thấy chủ đề với ChuDe_ID: $chuDeID');
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

}
