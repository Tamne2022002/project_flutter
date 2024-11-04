import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/chitiettraloi.dart';
import 'package:project_flutter/model/choigame.dart';
import 'package:project_flutter/model/topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPracticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserId() async {
    // Lấy người dùng hiện tại từ FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Nếu người dùng đã đăng nhập, trả về UID của họ
      
      return user.uid;
    } else {
      // Nếu chưa đăng nhập, trả về null
      return null;
    }
  }

  Future<DocumentSnapshot?> getUserDocumentByUid() async {
    String? uid = await getCurrentUserId();
    if (uid == null) {
      print("Người dùng chưa đăng nhập.");
      return null;
    }

    // Truy vấn collection `NguoiDung` bằng `nguoiDung_ID`
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('NguoiDung')
        .where('nguoiDung_ID', isEqualTo: uid)
        .limit(1) // Giới hạn chỉ lấy 1 document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Nếu tìm thấy, trả về document đầu tiên
      log("Current user ID: ${querySnapshot.docs.first}");
      return querySnapshot.docs.first;
    } else {
      print("Không tìm thấy người dùng với UID này.");
      return null;
    }
  }

  Future<List<ChoiGame>> getLuyenTapList() async {
    try {
      final querySnapshot = await _firestore
          .collection('ChoiGame')
          .where('theLoai', isEqualTo: 'luyentap')
          .where('nguoiDung_ID', isEqualTo: await getUserDocumentByUid())
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

        loadedLuyenTapList.add(ChoiGame(
          id: data['id'],
          boDe_ID: data['boDe_ID'],
          chuDe_ID: data['chuDe_ID'],
          nguoiDung_ID: data['nguoiDung_ID'],
          theLoai: data['theLoai'],
          tongDiem: data['tongDiem'],
          trangThai: data['trangthai'],
          create_at: createAt,
        ));
      }
      return loadedLuyenTapList;
    } catch (e) {
      log("Error loading a: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Future<List<ChiTietTraLoi>> getLuyenTapList() async {
  //   try {
  //     final querySnapshot = await _firestore.collection('CT_Traloi').where('theLoai', isEqualTo: 'luyentap').get();

  //     List<ChiTietTraLoi> loadedLuyenTapList = [];

  //     for (var doc in querySnapshot.docs) {
  //       var data = doc.data() as Map<String, dynamic>;

  //       // Chuyển đổi Timestamp sang DateTime nếu cần thiết
  //       DateTime? createAt;
  //       if (data['create_at'] != null) {
  //         createAt = (data['create_at'] is Timestamp)
  //             ? (data['create_at'] as Timestamp).toDate()
  //             : data['create_at'];
  //       }

  //       loadedLuyenTapList.add(ChiTietTraLoi(
  //         id: data['id'],
  //         bodeId: data['boDe_ID'],
  //         cauHoiId: data['cauHoi_ID'],
  //         diem: data['diem'],
  //         nguoiDungId: data['nguoiDung_ID'],
  //         dapAnId: data['dapAn_ID'],
  //         theLoai: data['theLoai'],
  //         thoiGianTraLoi: data['thoiGian_TL'],
  //         trangThai: data['trangthai'],
  //         createAt: createAt,
  //       ));
  //     }
  //     return loadedLuyenTapList;
  //   } catch (e) {
  //     log("Error loading: $e");
  //     return []; // Trả về danh sách rỗng nếu có lỗi
  //   }
  // }
}
