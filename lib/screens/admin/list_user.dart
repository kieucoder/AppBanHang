import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/screens/admin/crud_user.dart';

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

  Future<void> _loadUsers() async {
    print('Đang tải danh sách người dùng...');
    final users = await DBHelper.getAllUsers();
    setState(() {
      _users = users;
    });
    print('Danh sách người dùng: $_users');
  }

  Future<void> _deleteUser(int id, String hoten) async {
    final rows = await DBHelper.deleteUser(id);
    print('Số dòng bị xóa: $rows');
    _loadUsers();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa người dùng "$hoten"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Người dùng'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _users.isEmpty
          ? const Center(child: Text('Không có người dùng nào'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              title: Text(
                user['hoten'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mã: ${user['id']}'),
                    Text('Email: ${user['email']}'),
                    Text('Vai trò: ${user['role']}'),
                  ],
                ),
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserFormScreen(user: user),
                        ),
                      );
                      if (result == true) {
                        _loadUsers();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Cập nhật thành công!')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: Text(
                              'Bạn có chắc muốn xóa "${user['hoten']}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                await _deleteUser(
                                    user['id'], user['hoten']);
                              },
                              child: const Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          if (result == true) {
            _loadUsers();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm người dùng thành công!')),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm người dùng'), // Label chữ
        backgroundColor: Colors.blue,       // Màu nền (tuỳ chỉnh)
        foregroundColor: Colors.white,      // Màu chữ/icon
      ),

    );
  }
}
