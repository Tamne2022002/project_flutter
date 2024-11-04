import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/chitiettraloi.dart';

class ChiTietTraLoiService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('ChiTietTraLoi');

  Future<int> getNextChiTietTraLoiId() async {
    final snapshot = await firestore
        .collection('ChiTietTraLoi')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int highestId = snapshot.docs.first['id'] as int;
      return highestId + 1;
    } else {
      return 1; 
    }
  }

  Future<void> saveChiTietTraLoi(ChiTietTraLoi chiTietTraLoi) async {
    await _collection.add({
      'id': chiTietTraLoi.id,
      'gameId': chiTietTraLoi.gameId,
      'cauHoiId': chiTietTraLoi.cauHoiId,
      'diem': chiTietTraLoi.diem, 
      'thoiGianTraLoi': chiTietTraLoi.thoiGianTraLoi,
      'trangThai': chiTietTraLoi.trangThai,
      'createAt': chiTietTraLoi.createAt?.toIso8601String(),
    });
  }
}
