import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';

class LichSuDatTourScreen extends StatefulWidget {
  final int idUser;
  const LichSuDatTourScreen({super.key, required this.idUser});

  @override
  State<LichSuDatTourScreen> createState() => _LichSuDatTourScreenState();
}

class _LichSuDatTourScreenState extends State<LichSuDatTourScreen> {
  List<Map<String, dynamic>> _lichSu = [];

  @override
  void initState() {
    super.initState();
    _loadLichSu();
  }

  Future<void> _huyDonHang(int iddh) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper().updateTrangThaiDonHang(iddh, 'Đã hủy');
      await _loadLichSu(); // Refresh danh sách đơn hàng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được hủy!')),
      );
    }
  }



  Future<void> _loadLichSu() async {
    final data = await DBHelper().getLichSuDatTour(widget.idUser);
    setState(() {
      _lichSu = data;
    });
  }

  String _formatNgay(String ngay) {
    try {
      final date = DateTime.parse(ngay);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return ngay;
    }
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đặt tour'),
        centerTitle: true,

      ),
      body: _lichSu.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : ListView.builder(
        itemCount: _lichSu.length,
        itemBuilder: (context, index) {
          final order = _lichSu[index];
          return
            Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text('Mã ĐH: ${order['iddh']}'),
              subtitle: Text(
                'Ngày: ${_formatNgay(order['ngaydat'])}\n'
                    'Tổng: ${_formatCurrency(order['tongtien'])}\n'
                    'Trạng thái: ${order['trangthai']}',
              ),

              children: [
                ...List.generate(order['chitiet'].length, (i) {
                  final sp = order['chitiet'][i];
                  return ListTile(
                    leading: Image.asset(
                      sp['hinhanh'] ?? 'assets/no-image.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(sp['tensp']),
                    subtitle: Text(
                        'SL: ${sp['soluong']} x ${_formatCurrency(sp['gia'])}'
                    ),
                  );
                }),


                if (order['trangthai'] != 'Đã hủy')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _huyDonHang(order['iddh']),
                      // icon: const Icon(Icons.cancel),
                      label: const Text('Hủy đơn hàng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

              ],
            ),
          );
        },
      ),
    );
  }
}
