import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import 'checkout_screen.dart';

class GioHangScreen extends StatefulWidget {
  final int iduser; // ID của user đăng nhập
  const GioHangScreen({super.key, required this.iduser});

  @override
  State<GioHangScreen> createState() => _GioHangScreenState();
}

class _GioHangScreenState extends State<GioHangScreen> {
  List<Map<String, dynamic>> gioHang = [];
  double tongTien = 0.0;

  // Định dạng VNĐ
  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  @override
  void initState() {
    super.initState();
    _loadGioHang();
  }

  // Load danh sách giỏ hàng
  Future<void> _loadGioHang() async {
    final data = await DBHelper().getGioHang(widget.iduser);
    double total = 0;
    for (var item in data) {
      total += (item['gia'] as double) * (item['soluong'] as int);
    }
    setState(() {
      gioHang = data;
      tongTien = total;
    });
  }

  // Xóa sản phẩm khỏi giỏ
  Future<void> _xoaSanPham(int id) async {
    await DBHelper().deleteFromGioHang(id);
    _loadGioHang();
  }

  // Cập nhật số lượng
  Future<void> _capNhatSoLuong(int id, int newQty) async {
    if (newQty >= 1) {
      await DBHelper().updateSoLuong(id, newQty);
      _loadGioHang();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: Colors.indigo,
      ),
      body: gioHang.isEmpty
          ? const Center(
        child: Text(
          'Giỏ hàng trống',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: gioHang.length,
        itemBuilder: (context, index) {
          final item = gioHang[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Image.asset(
                item['hinhanh'] ?? 'assets/no-image.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(item['tensp']),
              subtitle: Text(
                "Giá: ${_formatCurrency(item['gia'])}\nSố lượng: ${item['soluong']}",
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle,
                        color: Colors.grey),
                    onPressed: () {
                      int newQty = (item['soluong'] as int) - 1;
                      _capNhatSoLuong(item['id'], newQty);
                    },
                  ),
                  Text('${item['soluong']}'),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.orange),
                    onPressed: () {
                      int newQty = (item['soluong'] as int) + 1;
                      _capNhatSoLuong(item['id'], newQty);
                    },
                  ),
                  IconButton(
                    icon:
                    const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _xoaSanPham(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: gioHang.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tổng tiền: ${_formatCurrency(tongTien)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Điều hướng đến trang thanh toán
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      iduser: widget.iduser,   // Lấy từ widget.iduser
                      // ID phải chính xác
                      tongTien: tongTien,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'TIẾN HÀNH THANH TOÁN',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
