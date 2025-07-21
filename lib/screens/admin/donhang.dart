import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/admin/chitietdonhang.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:intl/intl.dart';
class DonHangScreen extends StatefulWidget {
  final int iduser;
  const DonHangScreen({super.key, required this.iduser});

  @override
  State<DonHangScreen> createState() => _DonHangScreenState();
}

class _DonHangScreenState extends State<DonHangScreen> {
  List<Map<String, dynamic>> _donHangs = [];

  String formatNgay(String ngay) {
    final DateTime date = DateTime.parse(ngay); // Chuyển chuỗi ngày thành DateTime
    return DateFormat('dd/MM/yyyy').format(date); // Định dạng dd/MM/yyyy
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }



  @override
  void initState() {
    super.initState();
    _loadDonHangs();
  }

  Future<void> _loadDonHangs() async {
    final db = DBHelper();
    final allOrders = await db.getAllDonHang();
    // Lọc theo iduser
    setState(() {
      _donHangs = allOrders.where((e) => e['iduser'] == widget.iduser).toList();
    });
  }

  Future<void> _changeStatus(int iddh, String currentStatus) async {
    List<String> trangThaiList = ['Chờ xác nhận', 'Đang giao', 'Hoàn tất', 'Hủy'];

    String newStatus = trangThaiList.contains(currentStatus)
        ? currentStatus
        : trangThaiList[0];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // dùng StatefulBuilder để setState bên trong dialog
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Cập nhật trạng thái'),
              content: DropdownButton<String>(
                value: newStatus,
                isExpanded: true,
                items: trangThaiList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setStateDialog(() {
                    newStatus = value!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final db = DBHelper();
                    await db.updateTrangThaiDonHang(iddh, newStatus);
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
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        centerTitle: true,
      ),
      body: _donHangs.isEmpty
          ? const Center(child: Text('Bạn chưa có đơn hàng nào.'))
          : ListView.builder(
        itemCount: _donHangs.length,
        itemBuilder: (context, index) {
          final order = _donHangs[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Mã đơn: ${order['iddh']}'),
              subtitle: Text(
                'Ngày: ${formatNgay(order['ngaydat'])}\n'
                    'Tổng: ${_formatCurrency(order['tongtien'])}\n'
                    'Trạng thái: ${order['trangthai']}',
              ),
              trailing:IconButton(
                  onPressed: () => _changeStatus(order['iddh'],order['trangthai']),
                   icon: Icon(Icons.edit,color: Colors.blue,)),


              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChiTietDonHangScreen(iddh: order['iddh']),
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
