import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:project_flutter/model/choigame.dart';

class ChoiGameService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<ChoiGame>> loadChoiGame(int chuDeId) async {
    final snapshot = await firestore
        .collection('ChoiGame')
        .where('chuDe_ID', isEqualTo: chuDeId)
        .get();
        
    List<ChoiGame> choiGameList = snapshot.docs.map((doc) {
      var data = doc.data();
      ChoiGame choiGame = ChoiGame(
        id: data['id'],
        boDe_ID: data['boDe_ID'],
        chuDe_ID: data['chuDe_ID'],
        nguoiDung_ID: data['nguoiDung_ID'],
        theLoai: data['theLoai'],
        trangThai: data['trangThai'],
        create_at: (data['create_at'] as Timestamp?)?.toDate(),
        tongDiem: data['tongDiem'],
      );
      return choiGame;
    }).toList();
    return choiGameList;
  }

  Future<int> getNextGameId() async {
    final snapshot = await firestore
        .collection('ChoiGame')
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


  Future<void> saveGameResult(ChoiGame game) async {
    await firestore.collection('ChoiGame').add({
      'id': game.id,
      'boDe_ID': game.boDe_ID,
      'chuDe_ID': game.chuDe_ID,
      'nguoiDung_ID': game.nguoiDung_ID,
      'theLoai': game.theLoai,
      'trangThai': game.trangThai,
      'create_at': game.create_at,
      'tongDiem': game.tongDiem,
    });
  }
}
