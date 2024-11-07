import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/question.dart';

class QuestionService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Question>> loadQuestions(int chuDeid, int sluongcau) async {

    final snapshot = await firestore.collection('CauHoi')
        .where('ChuDe_ID', isEqualTo: chuDeid)
        .orderBy(FieldPath.documentId)
        .limit(sluongcau)
        .get();
    List<Question> loadedQuestions = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      loadedQuestions.add(Question(
        CauHoi_ID: data['CauHoi_ID'] ?? 0,
        ChuDe_ID: data['ChuDe_ID'] ?? 0,
        NgayTao: (data['NgayTao'] as Timestamp).toDate(),
        NoiDung_CauHoi: data['NoiDung'] ?? 'Không có nội dung',
        TrangThai: data['TrangThai'] ?? 0,
      ));
    }
    return loadedQuestions;
  }
}
