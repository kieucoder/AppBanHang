import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/chatbox.dart';
import 'package:shopbanhang/screens/lichsudattour.dart';
import 'package:shopbanhang/screens/account.dart';
import 'package:shopbanhang/screens/giohang_screen.dart';
import 'package:shopbanhang/screens/hometab.dart';
import 'package:shopbanhang/screens/timkiemsp.dart';




class HomeScreen extends StatefulWidget {
  final int iduser;
  final String username;


  const HomeScreen({
    super.key,
    required this.iduser,
    required this.username,
  });

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

  // Các màn hình tương ứng từng tab
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeTab(iduser: widget.iduser); // Trang chủ
      case 1:
        return const Center(child: Text('Danh mục')); // Tạm thời placeholder
      case 2:
        return LichSuDatTourScreen(idUser: widget.iduser);
      case 3:
        return ChatBox(userId: widget.iduser);
      case 4:
        return AccountScreen(username: widget.username);
      default:
        return const Center(child: Text('Không tìm thấy trang'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Giảm chiều cao AppBar
        backgroundColor: Colors.indigo,
        title: _selectedIndex == 4
            ? Text(
          'Xin chào, ${widget.username}!',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
            : Row(
          children: [
            // Logo nhỏ hơn
            Image.asset(
              'assets/logo.jpg',
              height: 35,
              width: 35,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),

            // Thanh tìm kiếm co giãn
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchProductScreen(iduser: widget.iduser),
                    ),
                  );
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey, size: 20),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Tìm kiếm sản phẩm...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Icon giỏ hàng
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GioHangScreen(iduser: widget.iduser),
                  ),
                );
              },
            ),


        IconButton(
          icon: const Icon(Icons.message, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatBox(userId: widget.iduser),
              ),

            );
          },
        ),




        ],
        ),
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
            label: 'Lịch sử',
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

