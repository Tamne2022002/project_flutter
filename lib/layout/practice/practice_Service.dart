import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/topic.dart';

class PracticeService {
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
}
