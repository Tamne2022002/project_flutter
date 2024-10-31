import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String hoTen, String email, String sdt, String matKhau, String xacNhanMK) async {
    try {
      // Tạo tài khoản người dùng
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: matKhau,
      );

      // Lưu thông tin bổ sung vào Firestore
      if (cred.user != null) {
        // Lấy ID người dùng hiện tại
        int nguoiDungID = await _getNextUserId();

        await _firestore.collection('NguoiDung').doc(cred.user!.uid).set({
          'hoTen': hoTen,
          'sdt': sdt,
          'email': email,
          'kinhNghiem': 1,
          'nguoiDung_ID': nguoiDungID,
          'phanQuyen_ID': 0,
          'trangThai': 1,
        });
      }
      
      return cred.user;
    } catch (e) {
      log("Error Register fail: $e");
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<int> _getNextUserId() async {
    // Lấy số lượng tài liệu trong collection 'NguoiDung'
    final snapshot = await _firestore.collection('NguoiDung').get();
    return snapshot.docs.length; // Trả về số lượng tài liệu hiện có
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String matKhau) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: matKhau,
      );
      return cred.user;
    } catch (e) {
      log("Error Login fail: $e");
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error Logout fail: $e");
    }
  }
}
