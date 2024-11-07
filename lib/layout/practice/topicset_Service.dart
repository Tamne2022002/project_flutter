import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/bode.dart';

class BoDeLayoutService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<BoDe>> loadBoDe(int chuDeId) async {  
    final snapshot = await firestore
        .collection('BoDe')
        .where('ChuDe_ID', isEqualTo: chuDeId)
        .get(); 
    List<BoDe> boDeList = snapshot.docs.map((doc) {
      var data = doc.data();
      BoDe boDe = BoDe(
        boDeId: data['BoDe_ID'],
        chuDeId: data['ChuDe_ID'],
        soLuongCau: data['SoLuongCau'],
        createAt: (data['create_at'] as Timestamp).toDate(),
        updateAt: (data['update_at'] as Timestamp).toDate(),
        trangThai: data['TrangThai'],
        tenChuDe: data['tenChuDe'] ?? '',
        chiTietBoDeList: [],
      );
      return boDe;
    }).toList(); 
    return boDeList;
  }
}
