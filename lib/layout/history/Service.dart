import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/DapAn.dart';
import 'package:project_flutter/model/account.dart';
import 'package:project_flutter/model/chitiettraloi.dart';
import 'package:project_flutter/model/choigame.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:project_flutter/model/chitietbode.dart';
import 'package:project_flutter/model/question.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HistoryPracticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<Account?> getUserDocumentByUid() async {
    if (user == null) {
      print("Người dùng chưa đăng nhập.");
      return null;
    }

    // Truy vấn collection `NguoiDung` bằng `email`
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('NguoiDung')
        .where('email', isEqualTo: user?.email)
        .limit(1) // Giới hạn chỉ lấy 1 document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Nếu tìm thấy, trả về document đầu tiên
      var userDetail = querySnapshot.docs
          .map((e) => Account(
              id: e['nguoiDung_ID'],
              name: e['hoTen'],
              email: e['email'],
              phone: e['sdt'],
              role: e['phanQuyen_ID'],
              xp: e['kinhNghiem']))
          .toList()
          .first;
      return userDetail;
    } else {
      print("Không tìm thấy người dùng với UID này.");
      return null;
    }
  }

  Future<List<ChoiGame>> getLuyenTapList() async {
    try {
      Account? userDetail = await getUserDocumentByUid();

      final querySnapshot = await _firestore
          .collection('ChoiGame')
          .where('theLoai', isEqualTo: 'luyentap')
          .where('nguoiDung_ID', isEqualTo: userDetail?.id)
          .get();

      List<ChoiGame> loadedLuyenTapList = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Chuyển đổi Timestamp sang DateTime nếu cần thiết
        DateTime? createAt;
        if (data['create_at'] != null) {
          createAt = (data['create_at'] is Timestamp)
              ? (data['create_at'] as Timestamp).toDate()
              : data['create_at'];
        }

        int trangthai;

        if (data['trangThai'] != null) {
          trangthai = data['trangThai'];
        } else {
          trangthai = 1;
        }

        // add collection to danh sách
        loadedLuyenTapList.add(ChoiGame(
          id: data['id'],
          boDe_ID: data['boDe_ID'],
          chuDe_ID: data['chuDe_ID'],
          nguoiDung_ID: data['nguoiDung_ID'],
          theLoai: data['theLoai'],
          tongDiem: data['tongDiem'],
          trangThai: trangthai,
          create_at: createAt,
        ));
      }

      return loadedLuyenTapList; // Trả về danh sách danh sách lịch sử luyện tập
    } catch (e) {
      log("Error loading a: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<Topic>> getChuDeList() async {
    try {
      final snapshot = await _firestore.collection('ChuDe').get();
      List<Topic> loadedTopics = [];
      // add collection to danh sách
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        loadedTopics.add(Topic(
          TenChuDe: data['TenChuDe'] ?? 'Không có tên',
          SLCauHoi: 0,
          ChuDe_ID: data['ChuDe_ID'] ?? 0,
        ));
      }

      return loadedTopics; // Trả về danh sách danh sách chủ đề
    } catch (e) {
      log("Error loading b: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  //Lấy danh sách cau hỏi ở bảng câu hỏi
  Future<List<Question>> getCauHoiList() async {
    try {
      final snapshot = await _firestore.collection('CauHoi').get();
      List<Question> loadedCauHoi = [];
      // add collection to danh sách
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        loadedCauHoi.add(Question(
          CauHoi_ID: data['CauHoi_ID'] ?? 0,
          ChuDe_ID: data['ChuDe_ID'] ?? 0,
          NgayTao: (data['NgayTao'] as Timestamp).toDate(),
          NoiDung_CauHoi: data['NoiDung'] ?? '',
          TrangThai: data['TrangThai'] ?? 1,
        ));
      }

      return loadedCauHoi; // Trả về danh sách danh sách chủ đề
    } catch (e) {
      log("Error loading d: $e");
      return []; // Trả về danh sách rằng này cò lỗi
    }
  }

  //Lấy danh sách đáp án
  Future<List<DapAn>> getDapAn() async {
    try {
      final snapshot = await _firestore.collection('DapAn').get();
      List<DapAn> loadedAnswer = [];
      // add collection to danh sách
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        loadedAnswer.add(DapAn(
          CauHoi_ID: data['CauHoi_ID'] ?? 0,
          ND_DapAn: data['ND_DapAn'] ?? '',
          DungSai: data['DungSai'] ?? false,
          Diem: data['Diem'] ?? 0,
          TrangThai: data['TrangThai'] ?? 1,
        ));
      }
      return loadedAnswer;
    } catch (e) {
      log("Error loading e: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  //Lấy danh sách đáp án

  Future<List<ChiTietTraLoi>> getCTTL(int gameId) async {
    try {
      final snapshot = await _firestore.collection('ChiTietTraLoi').where('gameId', isEqualTo: gameId).get();
      List<ChiTietTraLoi> loadedDetailAnswer = [];
      
      // add collection to danh sách
      for (var doc in snapshot.docs) {
        
        var data = doc.data() as Map<String, dynamic>;

        // Chuyển đổi Timestamp sang DateTime nếu cần thiết
        DateTime? createAt;
        if (data['create_at'] != null) {
          createAt = (data['create_at'] is Timestamp)
              ? (data['create_at'] as Timestamp).toDate()
              : data['create_at'];
        }

        loadedDetailAnswer.add(ChiTietTraLoi(
          id: data['id'] ?? 0,
          cauHoiId: data['cauHoiId'] ?? 0,
          diem: data['diem'] ?? 0,
          createAt: createAt,
          thoiGianTraLoi: data['thoiGianTraLoi'] ?? 0,
          trangThai: data['TrangThai'] ?? 1,
          gameId: data['gameId'] ?? 0,
        ));
      }
      return loadedDetailAnswer;
    } catch (e) {
      log("Error loading f: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }
}
