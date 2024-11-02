import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/account.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(String hoTen, String email,
      String sdt, String matKhau, String xacNhanMK) async {
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

  Future<bool> updateAccount(
      int id, String name, String email, String phone, int role) async {
    try {
      // Tìm tài liệu với nguoiDung_ID bằng id
      final snapshot = await _firestore
          .collection('NguoiDung')
          .where('nguoiDung_ID', isEqualTo: id)
          .limit(1) // Giới hạn kết quả về 1
          .get();

      // Kiểm tra xem tài liệu có tồn tại không
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên
        final docId = snapshot.docs.first.id;

        // Cập nhật tài liệu
        await _firestore.collection('NguoiDung').doc(docId).update({
          'hoTen': name,
          'email': email,
          'sdt': phone,
          'phanQuyen_ID': role,
        });
        return true; // Cập nhật thành công
      } else {
        log("No document found with nguoiDung_ID: $id");
        return false; // Không tìm thấy tài liệu
      }
    } catch (e) {
      log("Error updating account: $e");
      return false; // Có lỗi xảy ra
    }
  }

  // Hàm xóa tài khoản
  Future<bool> deleteAccount(int id) async {
  try {
    // Tìm tài liệu với nguoiDung_ID bằng id
    final snapshot = await _firestore
        .collection('NguoiDung')
        .where('nguoiDung_ID', isEqualTo: id)
        .limit(1)
        .get();

    print("Found ${snapshot.docs.length} documents for id $id"); // Debugging line

    if (snapshot.docs.isNotEmpty) {
      // Lấy ID tài liệu và xóa
      final docId = snapshot.docs.first.id;
      print("Deleting document with ID: $docId"); // Debugging line
      await _firestore.collection('NguoiDung').doc(docId).delete();
      return true; // Trả về true nếu thành công
    } else {
      print("No document found for id $id"); // Debugging line
      return false; // Không tìm thấy tài liệu
    }
  } catch (e) {
    log("Error deleting account: $e");
    return false; // Có lỗi xảy ra
  }
}


  Future<User?> createAdminUser(String hoTen, String email, String sdt,
      String matKhau, int phanQuyenID) async {
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
          'kinhNghiem': 1, // Giá trị mặc định
          'nguoiDung_ID': nguoiDungID,
          'phanQuyen_ID': phanQuyenID,
          'trangThai': 1,
        });
      }

      return cred.user;
    } catch (e) {
      log("Error Register fail: $e");
      return null; // Trả về null nếu có lỗi
    }
  }

  // Future<int> _getNextUserId() async {
  //   // Lấy số lượng tài liệu trong collection 'NguoiDung'
  //   final snapshot = await _firestore.collection('NguoiDung').get();
  //   return snapshot.docs.length; // Trả về số lượng tài liệu hiện có
  // }
  Future<int> _getNextUserId() async {
    // Lấy tất cả tài liệu trong collection 'NguoiDung'
    final snapshot = await _firestore.collection('NguoiDung').get();

    if (snapshot.docs.isEmpty) {
      return 1; // Nếu không có tài liệu, trả về ID bắt đầu là 1
    }

    // Tìm ID lớn nhất
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int? id = doc
          .data()['nguoiDung_ID']; // Giả sử ID lưu trong trường 'nguoiDung_ID'
      if (id != null && id > maxId) {
        maxId = id;
      }
    }

    return maxId + 1; // Trả về ID tiếp theo
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String matKhau) async {
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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent to $email");
    } catch (e) {
      log("Error sending password reset email: $e");
      throw e; // Ném lại lỗi để xử lý sau
    }
  }

  Future<List<Account>> loadAccounts() async {
    try {
      final snapshot = await _firestore.collection('NguoiDung').get();
      List<Account> loadedAccounts = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>; // Ép kiểu rõ ràng
        loadedAccounts.add(Account(
            name: data['hoTen'] ?? 'Không có tên',
            email: data['email'] ?? 'Không có email',
            phone: data['sdt'] ?? 'Không có số điện thoại',
            password: '', // Mật khẩu không nên lưu trong DB
            role: data['phanQuyen_ID'] ?? 0,
            xp: data['kinhNghiem'] ?? 0,
            id: data['nguoiDung_ID'] ?? 1 // Đảm bảo ID được khởi tạo đúng
            ));
      }

      return loadedAccounts;
    } catch (e) {
      log("Error loading accounts: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }
}
