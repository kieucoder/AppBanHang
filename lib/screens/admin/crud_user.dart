import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

class UserFormScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hotenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matkhauController = TextEditingController();
  final TextEditingController _confirmMatkhauController = TextEditingController();
  final TextEditingController _diachiController = TextEditingController();
  final TextEditingController _ngaysinhController = TextEditingController();

  String _role = 'User';
  String _gioitinh = 'Nam';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      print('Chỉnh sửa user: ${widget.user}');
      _hotenController.text = widget.user!['hoten'];
      _emailController.text = widget.user!['email'];
      _matkhauController.text = widget.user!['matkhau'];
      _confirmMatkhauController.text = widget.user!['matkhau'];
      _role = widget.user!['role'];
      _gioitinh = widget.user!['gioitinh'];
      _diachiController.text = widget.user!['diachi'];
      _ngaysinhController.text = widget.user!['ngaysinh'];
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final user = {
        'hoten': _hotenController.text,
        'email': _emailController.text,
        'matkhau': _matkhauController.text,
        'role': _role,
        'gioitinh': _gioitinh,
        'diachi': _diachiController.text,
        'ngaysinh': _ngaysinhController.text,
      };

      if (widget.user == null) {
        final id = await DBHelper.insertUser(user);
        print('Thêm user thành công với ID: $id');
      } else {
        user['id'] = widget.user!['id'];
        final rows = await DBHelper.updateUser(user);
        print('Cập nhật user ID ${user['id']} - Rows affected: $rows');
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Thêm Người dùng' : 'Chỉnh sửa Người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _hotenController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập email';
                  if (!_isValidEmail(value)) return 'Email không hợp lệ';
                  return null;
                },
              ),
              TextFormField(
                controller: _matkhauController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),
              TextFormField(
                controller: _confirmMatkhauController,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                  if (value != _matkhauController.text) return 'Mật khẩu xác nhận không khớp';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _role,
                items: ['User', 'Admin'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) => setState(() => _role = value!),
                decoration: const InputDecoration(labelText: 'Quyền'),
              ),
              const SizedBox(height: 10),
              const Text('Giới tính', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nam'),
                      value: 'Nam',
                      groupValue: _gioitinh,
                      onChanged: (value) => setState(() => _gioitinh = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nữ'),
                      value: 'Nữ',
                      groupValue: _gioitinh,
                      onChanged: (value) => setState(() => _gioitinh = value!),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _diachiController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextFormField(
                controller: _ngaysinhController,
                decoration: const InputDecoration(labelText: 'Ngày sinh (dd/MM/yyyy)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: Text(widget.user == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
