import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/question.dart';
import 'package:project_flutter/admin/ChuDe/ChuDe_Service.dart'; // Thêm import này

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TopicService _topicService = TopicService(); // Khởi tạo dịch vụ chủ đề

  // Hàm để thêm câu hỏi
  Future<void> addQuestion(Question question) async {
    await _firestore.collection('CauHoi').add({
      'NoiDung': question.NoiDung_CauHoi,
      'ChuDe_ID': question.ChuDe_ID,
      'createdDate': question.createdDate,
      'TrangThai': question.TrangThai,
    });
  }

  // Hàm để cập nhật câu hỏi
  Future<void> updateQuestion(Question question) async {
    await _firestore.collection('CauHoi').doc(question.CauHoi_ID.toString()).update({
      'NoiDung': question.NoiDung_CauHoi,
      'ChuDe_ID': question.ChuDe_ID,
    });
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
      createdDate: data['NgayTao'],
      NoiDung_CauHoi: data['NoiDung'],
      TrangThai: data['TrangThai'],
      TenChuDe: '', // Bạn có thể để giá trị tạm thời ở đây
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

}
