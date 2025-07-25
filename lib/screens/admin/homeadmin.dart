
// import 'package:flutter/material.dart';
// import 'package:shopbanhang/screens/admin/adminchat.dart';
// import 'package:shopbanhang/screens/admin/donhang.dart';
// import 'package:shopbanhang/screens/admin/list_sp.dart';
// import 'package:shopbanhang/screens/admin/list_danhmuc.dart';
// import 'package:shopbanhang/screens/admin/accountadmin.dart';
// import 'package:shopbanhang/screens/admin/list_chat.dart';
//
//
// class AdminHomeScreen extends StatefulWidget {
//   final String adminName;
//
//
//   const AdminHomeScreen({Key? key, required this.adminName}) : super(key: key);
//
//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }
//
// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   int _selectedIndex = 0;
//
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       const UserListScreen(),
//       const ListSanPhamScreen(),
//       const ListDanhMucScreen(),
//       // const DonHangScreen(iduser: 1,),
//       // ChatBox(userId: 0, isAdminView: true),
//       const AdminChatListScreen(),
//       const Center(child: Text("Tin nhắn")), // hoặc Chat tổng
//       AdminAccountScreen(adminName: widget.adminName), // Trang tài khoản admin
//     ];
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, //bỏ dấu mũi tên quay lại
//         title: Text('Admin - ${widget.adminName}'),
//         backgroundColor: const Color(0xFF3A3A3A),
//         foregroundColor: Colors.white,
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: const Color(0xFF3B82F6),  // Xanh dương nổi bật
//         unselectedItemColor: Colors.grey.shade400,   // Xám nhạt
//
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Người dùng'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Sản phẩm'),
//           BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Danh mục'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
//           BottomNavigationBarItem(icon: Icon(Icons.message), label:'Tin nhắn'),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Tài khoản'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/admin/list_user.dart';
import 'package:shopbanhang/screens/admin/list_sp.dart';
import 'package:shopbanhang/screens/admin/list_danhmuc.dart';
import 'package:shopbanhang/screens/admin/accountadmin.dart';
import 'package:shopbanhang/screens/admin/list_chat.dart';
import 'package:shopbanhang/screens/admin/donhang.dart';
class AdminHomeScreen extends StatefulWidget {
  final String adminName;


  const AdminHomeScreen({Key? key, required this.adminName}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const UserListScreen(),
      const ListSanPhamScreen(),
      const ListDanhMucScreen(),
      const DonHangAdminScreen(),
      const AdminChatListScreen(),
      AdminAccountScreen(adminName: widget.adminName),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Nền xám đậm toàn màn hình
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin - ${widget.adminName}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2C2C2C), // Màu xám đậm hiện đại
        elevation: 0, // Bỏ bóng AppBar
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF2C2C2C), // Nền xám đậm
        selectedItemColor: const Color(0xFF3B82F6), // Xanh dương nổi bật
        unselectedItemColor: Colors.grey.shade500,  // Xám nhạt
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Người dùng'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Sản phẩm'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Danh mục'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long),label:'Hóa đơn'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Tin nhắn'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
