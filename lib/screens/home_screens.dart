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
        return LichSuDatTourScreen(idUser: widget.iduser);
      case 2:
        // return LichSuDatTourScreen(idUser: widget.iduser);
        return ChatBox(userId: widget.iduser);
      case 3:
        // return ChatBox(userId: widget.iduser);
      case 4:
        return AccountScreen(username: widget.username);
      default:
        return const Center(child: Text('Không tìm thấy trang'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Chiều cao AppBar
        child: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 4, // Đổ bóng nhẹ
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0, // Bỏ khoảng cách mặc định
          title: _selectedIndex == 4
              ? Text(
            'Xin chào, ${widget.username}!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
              : Row(
            children: [
              // Khung tìm kiếm (chiếm gần hết AppBar)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey, size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tìm kiếm sản phẩm...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Icon giỏ hàng
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GioHangScreen(iduser: widget.iduser),
                    ),
                  );
                },
              ),
              // Icon chat
              IconButton(
                icon: const Icon(Icons.message_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatBox(userId: widget.iduser),
                    ),
                  );
                },
              ),



            ],
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Lịch sử'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
        ],
      ),
    );
  }


}



