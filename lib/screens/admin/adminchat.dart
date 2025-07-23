import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/chatbox.dart';
import 'package:shopbanhang/database/db_helper.dart';

class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({Key? key}) : super(key: key);

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  final DBHelper _db = DBHelper();
  List<Map<String, dynamic>> _chatUsers = [];

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
  }

  /// Lấy danh sách tất cả user đã chat với admin
  Future<void> _loadChatUsers() async {
    try {
      final data = await _db.getAllChatUsers();
      setState(() {
        _chatUsers = data;
      });
    } catch (e) {
      print("Lỗi load danh sách chat user: $e");
    }
  }

  /// UI cho 1 item user chat
  Widget _buildChatUserItem(Map<String, dynamic> chatUser) {
    final userId = chatUser['user_id'];
    final lastMessageTime = chatUser['last_message_time'];

    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text("User #$userId"),
      subtitle: Text("Hoạt động cuối: $lastMessageTime"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBox(
              userId: userId,
              isAdminView: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách chat với User"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadChatUsers,
        child: _chatUsers.isEmpty
            ? const Center(child: Text("Chưa có người dùng chat"))
            : ListView.separated(
          itemCount: _chatUsers.length,
          separatorBuilder: (context, index) =>
          const Divider(height: 1),
          itemBuilder: (context, index) {
            return _buildChatUserItem(_chatUsers[index]);
          },
        ),
      ),
    );
  }
}
