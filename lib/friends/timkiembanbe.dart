import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_flutter/color/Color.dart';


class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _searchResults = [];

  void _searchUser() async {
    String searchText = _searchController.text.trim();
    if (searchText.isEmpty) return;

    try {
      // Tìm kiếm người dùng theo tên hoặc email
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('NguoiDung')
          .where('hoTen', isEqualTo: searchText)
          .get();

      setState(() {
        _searchResults = result.docs;
      });
    } catch (e) {
      print("Lỗi khi tìm kiếm: $e");
    }
  }

  Future<void> _sendFriendRequest(String friend_ID) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("Người dùng chưa đăng nhập.");
      return;
    }

    try {
      // Thêm bạn vào subcollection friends của người dùng hiện tại
      await FirebaseFirestore.instance
          .collection('NguoiDung')
          .doc(currentUser.uid)
          .collection('friends')
          .doc(friend_ID)
          .set({'addedAt': FieldValue.serverTimestamp()});

      // Thêm người dùng hiện tại vào danh sách bạn bè của bạn
      await FirebaseFirestore.instance
          .collection('NguoiDung')
          .doc(friend_ID)
          .collection('friends')
          .doc(currentUser.uid)
          .set({'addedAt': FieldValue.serverTimestamp()});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã gửi yêu cầu kết bạn thành công")),
      );
    } catch (e) {
      print("Lỗi khi gửi yêu cầu kết bạn: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra: $e")),
      );
    }
  }
bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
        appBar: AppBar(
          backgroundColor: AppColors.btnColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "TÌM KIẾM BẠN BÈ",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _isFocused = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _isFocused = false;
                });
              },
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nhập tên hoặc email',
                labelStyle: TextStyle(color: _isFocused ? Colors.white : Colors.white,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,),
                  ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search,color: Colors.white),
                  onPressed: _searchUser,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var user = _searchResults[index];
                  String userId = user.id;
                  String name = user['hoTen'];
                  String email = user['email'];

                  return ListTile(
                    title: Text(name,style: TextStyle(fontSize: 16, color: Colors.white),),
                    subtitle: Text(email,style: TextStyle(fontSize: 16, color: Colors.white),),
                    trailing: ElevatedButton(
                      onPressed: () => _sendFriendRequest(userId),
                      child: Text('Kết bạn'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
