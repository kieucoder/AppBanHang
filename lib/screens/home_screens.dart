import 'dart:async';
import 'package:flutter/material.dart';
import 'account.dart';
import 'add_danhmuc.dart';
import 'hometab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiệm Sữa 4CE',
      // theme: ThemeData(
      //   primarySwatch: Colors.orange,
      // ),
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu xanh biển mặc định
        scaffoldBackgroundColor: const Color(0xFFF2F4F6), // nền nhẹ
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0), // xanh biển đậm
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1565C0), // xanh biển đậm
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1565C0), // xanh biển đậm
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(size: 26),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(username: 'Khách'),
    );
  }
}



class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Gọi các màn hình tương ứng với từng tab
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeTab(); // Trang chủ đã tách riêng
      case 1:
        return const ThemDanhMucScreen();
      case 2:
        return const Center(child: Text('Tin tức'));
      case 3:
        return const Center(child: Text('Thông báo'));

      case 4:
        return AccountScreen(username: widget.username); // ✅ đúng tên

// ✅ Đúng tên tham số
      default:
        return const Center(child: Text('Không tìm thấy trang'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: _selectedIndex == 4
            ? Text(
          'Xin chào, ${widget.username}!',
          style: const TextStyle(fontSize: 16),
        )
            : Row(
          children: [
            Image.asset('assets/logo.jpg', height: 40),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),

      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Danh mục',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tin tức',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );



  }
}
