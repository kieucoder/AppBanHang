//
// import 'package:flutter/material.dart';
// import 'package:shopbanhang/database/db_helper.dart';
// import 'package:shopbanhang/main.dart';
// import '../models/user.dart';
// import 'login_screen.dart';
//
//
// class AccountScreen extends StatefulWidget {
//   final String username;
//
//   const AccountScreen({super.key, required this.username});
//
//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }
//
// class _AccountScreenState extends State<AccountScreen> {
//   User? user;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserInfo();
//   }
//
//   Future<void> _loadUserInfo() async {
//     final allUsers = await DBHelper.getAllUsers();
//     final userData = allUsers.firstWhere(
//           (element) => element['hoten'] == widget.username,
//       orElse: () => {},
//     );
//
//     if (userData.isNotEmpty) {
//
//       setState(() {
//         user = User.fromMap(userData);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F6),
//       body: user == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.orange.shade200,
//               child: const Icon(Icons.person, size: 50, color: Colors.white),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               user!.hoten,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(user!.email, style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 24),
//             _buildInfoCard(" Họ tên", user!.hoten),
//             _buildInfoCard(" Giới tính", user!.gioitinh),
//             _buildInfoCard(" Ngày sinh", user!.ngaysinh),
//             _buildInfoCard(" Địa chỉ", user!.diachi),
//
//             // Nếu có thêm nội dung, dùng Expanded để cuộn:
//             // Expanded(child: Container()),
//           ],
//         ),
//       ),
//
//       // đây là phần ghim nút Đăng xuất vào đáy màn hình
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//         child: SizedBox(
//           height: 50,
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text(
//               'Đăng xuất',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//             style: ElevatedButton.styleFrom(
//
//               backgroundColor: Colors.indigo, // nền trắng
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 side: const BorderSide(color: Colors.lightBlue), // viền xanh biển nhạt
//               ),
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildInfoCard(String title, String value) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: const Icon(Icons.info, color: Colors.indigo),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(value),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/user.dart';
import 'package:shopbanhang/screens/doimatkhau.dart';
import 'package:shopbanhang/screens/login_screen.dart';


class AccountScreen extends StatefulWidget {
  final String username; // Tên đăng nhập hoặc tên hiển thị

  const AccountScreen({super.key, required this.username});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final allUsers = await DBHelper.getAllUsers();
    final userData = allUsers.firstWhere(
          (element) => element['hoten'] == widget.username,
      orElse: () => {},
    );

    if (userData.isNotEmpty) {
      setState(() {
        user = User.fromMap(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange.shade200,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              user!.hoten,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(user!.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Nút đổi mật khẩu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock, color: Colors.white),
                label: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangePasswordScreen(userId: user!.id),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Thông tin chi tiết
            _buildInfoCard("Họ tên", user!.hoten),
            _buildInfoCard("Giới tính", user!.gioitinh),
            _buildInfoCard("Ngày sinh", user!.ngaysinh),
            _buildInfoCard("Địa chỉ", user!.diachi),
          ],
        ),
      ),

      // Nút Đăng xuất ở cuối màn hình
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.info, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}



