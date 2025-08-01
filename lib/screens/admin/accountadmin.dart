
import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/login_screen.dart';
import 'package:shopbanhang/database/db_helper.dart';

class AdminAccountScreen extends StatefulWidget {
  final String adminName;

  const AdminAccountScreen({Key? key, required this.adminName}) : super(key: key);

  @override
  State<AdminAccountScreen> createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  Map<String, dynamic>? _adminInfo;

  @override
  void initState() {
    super.initState();
    _loadAdminInfo();
  }

  Future<void> _loadAdminInfo() async {
    final db = DBHelper();
    final admin = await db.getUserByName(widget.adminName);
    setState(() {
      _adminInfo = admin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _adminInfo == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tiêu đề
            const Text(
              'Thông tin Admin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Card chứa thông tin
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: AssetImage('assets/logoadmin.jpg'),
                      // child: const Icon(Icons.admin_panel_settings, size: 50, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _adminInfo!['hoten'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Dùng ListTile cho từng dòng thông tin
                    _buildInfoTile(Icons.email, 'Email', _adminInfo!['email']),
                    _buildInfoTile(Icons.person, 'Giới tính', _adminInfo!['gioitinh']),
                    _buildInfoTile(Icons.home, 'Địa chỉ', _adminInfo!['diachi']),
                    _buildInfoTile(Icons.cake, 'Ngày sinh', _adminInfo!['ngaysinh']),
                    _buildInfoTile(Icons.verified_user, 'Quyền', 'Quản trị viên'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nút Đăng xuất
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget tạo dòng thông tin với icon và text
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
