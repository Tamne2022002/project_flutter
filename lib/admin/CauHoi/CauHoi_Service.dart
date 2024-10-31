import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart';
import 'package:project_flutter/model/DapAn.dart';
import 'package:project_flutter/model/question.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TopicService _topicService = TopicService();

  // Hàm để thêm câu hỏi
  Future<void> addQuestion(Question question) async {
    await _firestore.collection('CauHoi').add({
      'CauHoi_ID': question.CauHoi_ID,
      'NoiDung': question.NoiDung_CauHoi,
      'ChuDe_ID': question.ChuDe_ID,
      'NgayTao': question.NgayTao,
      'TrangThai': question.TrangThai,
    });
  }

  // Hàm để cập nhật câu hỏi
  Future<void> updateQuestion(Question question) async {
    var querySnapshot = await _firestore
        .collection('CauHoi')
        .where('CauHoi_ID', isEqualTo: question.CauHoi_ID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'NoiDung': question.NoiDung_CauHoi,
        'ChuDe_ID': question.ChuDe_ID,
      });
    } else {
      throw Exception('Không tìm thấy câu hỏi với ID: ${question.CauHoi_ID}');
    }
  }

  // Hàm để lấy danh sách câu hỏi
  Future<List<Question>> loadQuestions() async {
    final snapshot = await _firestore.collection('CauHoi').get();
    List<Question> loadedQuestions = [];
    List<Future<void>> futures = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var question = Question(
        CauHoi_ID: data['CauHoi_ID'],
        ChuDe_ID: data['ChuDe_ID'],
        NgayTao: (data['NgayTao'] as Timestamp).toDate(),
        NoiDung_CauHoi: data['NoiDung'],
        TrangThai: data['TrangThai'],
        TenChuDe: '', // Tạm thời để trống, sẽ được cập nhật sau
      );

      futures.add(
        _topicService.getTenChuDe(question.ChuDe_ID).then((tenChuDe) {
          question.TenChuDe = tenChuDe; // Cập nhật tên chủ đề
        }),
      );

      loadedQuestions.add(question);
    }

    await Future.wait(futures); // Chờ tất cả các tương lai hoàn thành
    return loadedQuestions;
  }

  // Hàm để xóa câu hỏi
  Future<void> deleteQuestion(int cauHoiID) async {
    var querySnapshot = await _firestore
        .collection('CauHoi')
        .where('CauHoi_ID', isEqualTo: cauHoiID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    } else {
      throw Exception('Không tìm thấy câu hỏi với ID: $cauHoiID');
    }
  }

  // Hàm để thêm đáp án
  Future<void> addAnswer(DapAn answer) async {
    await _firestore.collection('DapAn').add({
      'CauHoi_ID': answer.CauHoi_ID,
      'ND_DapAn': answer.ND_DapAn,
      'DungSai': answer.DungSai,
      'Diem': answer.Diem,
      'TrangThai': answer.TrangThai,
    });
  }
}
