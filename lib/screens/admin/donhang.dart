
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/screens/admin/chitietdonhang.dart';

class DonHangAdminScreen extends StatefulWidget {
  const DonHangAdminScreen({super.key});

  @override
  State<DonHangAdminScreen> createState() => _DonHangAdminScreenState();
}

class _DonHangAdminScreenState extends State<DonHangAdminScreen> {
  List<Map<String, dynamic>> _donHangs = [];

  @override
  void initState() {
    super.initState();
    _loadDonHangs();
  }

  Future<void> _loadDonHangs() async {
    final db = DBHelper();
    final allOrders = await db.getAllDonHang(); // Lấy tất cả đơn hàng
    setState(() {
      _donHangs = allOrders;
    });
  }

  String _formatDate(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }

  String _formatCurrency(double price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  /// Hàm trả về màu sắc dựa trên trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange.shade100;
      case 'Đang giao':
        return Colors.blue.shade100;
      case 'Hoàn tất':
        return Colors.green.shade100;
      case 'Đã hủy':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Future<void> _changeStatus(int iddh, String currentStatus) async {
    // Danh sách trạng thái để hiển thị
    List<String> statuses = ['Chờ xác nhận', 'Đang giao', 'Hoàn tất', 'Hủy'];

    // Nếu đơn hàng đã hủy, không cho phép thay đổi
    if (currentStatus == 'Đã hủy') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã bị hủy, không thể thay đổi trạng thái.')),
      );
      return;
    }
    else if (currentStatus == "Hoàn tất"){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã Hoàn tất, khng thể thay đổi trạng thái.'))
      );
      return;
    }


    // Đồng bộ trạng thái hiện tại từ DB ('Đã hủy' -> 'Hủy')
    String newStatus = currentStatus == 'Đã hủy' ? 'Hủy' : currentStatus;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Cập nhật trạng thái'),
              content: DropdownButton<String>(
                value: newStatus,
                items: statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setStateDialog(() => newStatus = value!);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Khi lưu, nếu chọn 'Hủy' thì đổi thành 'Đã hủy'
                    final saveStatus = (newStatus == 'Hủy') ? 'Đã hủy' : newStatus;
                    await DBHelper().updateTrangThaiDonHang(iddh, saveStatus);
                    Navigator.pop(context);
                    _loadDonHangs();
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: _donHangs.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : ListView.builder(
        itemCount: _donHangs.length,
        itemBuilder: (context, index) {
          final order = _donHangs[index];
          final bgColor = _getStatusColor(order['trangthai']);
          return Card(
            color: bgColor,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.indigo),
              title: Text('Mã đơn: ${order['iddh']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(
                'Khách hàng: ${order['tennguoidat'] ?? 'Không rõ'}\n'
                    'Ngày đặt: ${_formatDate(order['ngaydat'])}\n'
                    'Tổng: ${_formatCurrency(order['tongtien'])}\n'
                    'Thanh toán: ${order['phuongthucthanhtoan']}\n'
                    'Trạng thái: ${order['trangthai']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _changeStatus(order['iddh'], order['trangthai']),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChiTietDonHangScreen(
                      iddh: order['iddh'],
                      // isAdmin: true,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
