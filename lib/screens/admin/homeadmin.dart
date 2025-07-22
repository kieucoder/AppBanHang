


import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/admin/donhang.dart';
import 'package:shopbanhang/screens/admin/list_user.dart';
import 'package:shopbanhang/screens/admin/list_sp.dart';
import 'package:shopbanhang/screens/admin/list_danhmuc.dart';
import 'package:shopbanhang/screens/admin/accountadmin.dart';

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
      const DonHangScreen(iduser: 1,),
      AdminAccountScreen(adminName: widget.adminName), // Trang tài khoản admin
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
      appBar: AppBar(
        automaticallyImplyLeading: false, //bỏ dấu mũi tên quay lại
        title: Text('Admin - ${widget.adminName}'),
        backgroundColor: Colors.orange,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Người dùng'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Sản phẩm'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Danh mục'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
