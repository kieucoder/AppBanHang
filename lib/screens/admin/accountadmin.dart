// import 'package:flutter/material.dart';
//
// class AdminAccountScreen extends StatelessWidget {
//
//   final Map<String, dynamic> adminInfo;
//
//   const AdminAccountScreen({Key? key, required this.adminInfo}) : super(key: key);
//
//   void _logout(BuildContext context) {
//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20),
//           CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.orange.shade300,
//             child: const Icon(Icons.person, size: 60, color: Colors.white),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             adminInfo['hoten'] ?? 'Admin',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             adminInfo['email'] ?? 'admin@gmail.com',
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           _buildInfoCard('Quyền', adminInfo['role'] ?? 'Admin'),
//           _buildInfoCard('Địa chỉ', adminInfo['diachi'] ?? 'Chưa có'),
//           _buildInfoCard('Giới tính', adminInfo['gioitinh'] ?? 'Chưa rõ'),
//           _buildInfoCard('Ngày sinh', adminInfo['ngaysinh'] ?? 'Chưa có'),
//           const SizedBox(height: 30),
//           ElevatedButton.icon(
//             onPressed: () => _logout(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text(
//               'Đăng xuất',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(String label, String value) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: const Offset(1, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }


//
//
// import 'package:flutter/material.dart';
// import 'package:shopbanhang/screens/login_screen.dart';
//
// class AdminAccountScreen extends StatelessWidget {
//   final String adminName;
//
//   const AdminAccountScreen({Key? key, required this.adminName}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Thông tin Admin',
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           Text('Tên: $adminName', style: const TextStyle(fontSize: 18)),
//           const SizedBox(height: 8),
//           const Text('Quyền: Quản trị viên', style: TextStyle(fontSize: 18)),
//           const Spacer(),
//       Center(
//         child: ElevatedButton.icon(
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const LoginScreen(
//                 ),
//               ),
//                   (route) => false, // Xóa toàn bộ stack
//             );
//           },
//           icon: const Icon(Icons.logout),
//           label: const Text('Đăng xuất'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       )
//
//       ],
//       ),
//     );
//   }
// }
//

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
