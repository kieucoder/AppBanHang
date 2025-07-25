import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/admin/adminchat.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:intl/intl.dart';
// intl định dạng ngày giờ




class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({Key? key}) : super(key: key);

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  final DBHelper _db = DBHelper();
  List<Map<String, dynamic>> _chatUsers = [];


  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadChatUsers();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

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


  //hàm để hiển thị thời gian hoạt động
  String _formatLastActive(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inMinutes < 1) return "Vừa xong";
      if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
      if (diff.inHours < 24) return "${diff.inHours} giờ trước";

      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return isoTime;
    }
  }




  Widget _buildChatUserItem(Map<String, dynamic> chatUser) {
    final userId = chatUser['user_id'];
    final lastMessageTime = chatUser['last_message_time'];
    final formattedTime = _formatLastActive(lastMessageTime);
    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue,

        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text("User mã $userId"),
      subtitle: Text("Hoạt động cuối: ${_formatLastActive(lastMessageTime)}"),

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
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text("Danh sách chat với User"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadChatUsers,
        child: _chatUsers.isEmpty
            ? const Center(child: Text("Chưa có người dùng chat"))
            : ListView.separated(
          itemCount: _chatUsers.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return _buildChatUserItem(_chatUsers[index]);
          },
        ),
      ),
    );
  }
}
