import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/DapAn.dart';

class DapAnService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DapAn>> loadAnswers(int questionId) async {
    final snapshot = await firestore.collection('DapAn')
        .where('CauHoi_ID', isEqualTo: questionId)
        .get();
    List<DapAn> loadedAnswers = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      loadedAnswers.add(DapAn(
        CauHoi_ID: data['CauHoi_ID'] ?? 0,
        ND_DapAn: data['ND_DapAn'] ?? 'Không có đáp án',
        DungSai: data['DungSai'] ?? false,
        Diem: data['Diem'] ?? 0,
        TrangThai: data['TrangThai'] ?? 0,
      ));
    }

    return loadedAnswers;
  }
}
