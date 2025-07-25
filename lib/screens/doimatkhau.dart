import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;

  const ChangePasswordScreen({super.key, required this.userId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await DBHelper().getUserById(widget.userId);
    if (mounted) {
      setState(() {
        _userData = user;
      });
    }
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userData == null) return;

    setState(() => _isLoading = true);

    try {
      final currentPass = _currentPassController.text.trim();
      final newPass = _newPassController.text.trim();

      // Kiểm tra mật khẩu hiện tại
      if (_userData!['matkhau'] != currentPass) {
        _showDialog("Mật khẩu hiện tại không chính xác!");
        setState(() => _isLoading = false);
        return;
      }

      // Cập nhật mật khẩu
      await DBHelper().updateUserPassword(widget.userId, newPass);

      _showDialog("Đổi mật khẩu thành công!", isSuccess: true);
    } catch (e) {
      _showDialog("Có lỗi xảy ra: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Thông báo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSuccess) Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF21409A)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F4F6),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock, size: 100, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text(
                'Cập nhật mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 30),

              // Mật khẩu hiện tại
              _buildPasswordField(
                controller: _currentPassController,
                label: "Mật khẩu hiện tại",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập mật khẩu hiện tại";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mật khẩu mới
              _buildPasswordField(
                controller: _newPassController,
                label: "Mật khẩu mới",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập mật khẩu mới";
                  }
                  if (value.length < 6) {
                    return "Mật khẩu mới phải ít nhất 6 ký tự";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Xác nhận mật khẩu mới
              _buildPasswordField(
                controller: _confirmPassController,
                label: "Xác nhận mật khẩu mới",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng xác nhận mật khẩu mới";
                  }
                  if (value != _newPassController.text) {
                    return "Mật khẩu xác nhận không khớp";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Nút Đổi mật khẩu
              ElevatedButton(
                onPressed: _isLoading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
      ),
      validator: validator,
    );
  }
}
