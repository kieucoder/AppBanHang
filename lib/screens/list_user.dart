import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserListScreen(),
  ));
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await DBHelper.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
        backgroundColor: Colors.indigo,
      ),
      body: _users.isEmpty
          ? const Center(child: Text('Không có người dùng nào'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Text(
                  user['hoten'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user['hoten'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📧 ${user['email']}'),
                  Text('🔐 Mật khẩu: ${user['matkhau']}'),
                  Text('📅 Ngày sinh: ${user['ngaysinh']}'),
                  Text('👤 Giới tính: ${user['gioitinh']}'),
                  Text('🏠 Địa chỉ: ${user['diachi']}'),
                ],
              ),
              trailing: Chip(
                label: Text(user['role']),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          );
        },
      ),
    );
  }
}