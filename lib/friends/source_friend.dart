import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_flutter/model/account.dart';

class AuthFriend {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addFriend(String nguoiDung_ID, String friend_ID) async {
  try {
    // Thêm friendId vào danh sách bạn bè của người dùng
    await _firestore.collection('NguoiDung').doc(nguoiDung_ID).collection('friends').doc(friend_ID).set({
      'friend_ID': friend_ID,
      'addedAt': FieldValue.serverTimestamp(),
    });

    // Thêm userId vào danh sách bạn bè của người bạn
    await _firestore.collection('NguoiDung').doc(friend_ID).collection('friends').doc(nguoiDung_ID).set({
      'friend_ID': nguoiDung_ID,
      'addedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error adding friend: $e");
  }
}
Future<List<String>> getFriendsList(String nguoiDung_ID) async {

  try {
    QuerySnapshot snapshot = await _firestore
        .collection('NguoiDung')
        .doc(nguoiDung_ID)
        .collection('friends')
        .get();

    return snapshot.docs.map((doc) => doc['friend_ID'] as String).toList();
  } catch (e) {
    print("Error getting friends list: $e");
    return [];
  }
}
}