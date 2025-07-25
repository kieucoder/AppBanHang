import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';

class ChiTietDonHangScreen extends StatefulWidget {
  final int iddh;

  const ChiTietDonHangScreen({
    super.key,
    required this.iddh,
  });

  @override
  State<ChiTietDonHangScreen> createState() => _ChiTietDonHangScreenState();
}

class _ChiTietDonHangScreenState extends State<ChiTietDonHangScreen> {
  Map<String, dynamic>? _donHang;
  List<Map<String, dynamic>> _chiTiet = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load thông tin đơn hàng và chi tiết đơn hàng
  Future<void> _loadData() async {
    final db = DBHelper();
    final order = await db.getDonHangById(widget.iddh);
    final details = await db.getChiTietDonHang(widget.iddh);

    setState(() {
      _donHang = order;
      _chiTiet = details;
    });
  }

  String _formatCurrency(double price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  String _formatDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.iddh}'),
        backgroundColor: Colors.orange,
      ),
      body: _donHang == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin chung đơn hàng
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn hàng: #${_donHang!['iddh']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        'Người đặt: ${_donHang!['tennguoidat'] ?? 'Không rõ'}'),
                    Text('Ngày đặt: ${_formatDate(_donHang!['ngaydat'])}'),
                    Text('Phương thức: ${_donHang!['phuongthucthanhtoan']}'),
                    Text(
                      'Trạng thái: ${_donHang!['trangthai']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    Text(
                      'Tổng tiền: ${_formatCurrency(_donHang!['tongtien'])}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Chi tiết sản phẩm:',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // Danh sách chi tiết sản phẩm
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _chiTiet.length,
              itemBuilder: (context, index) {
                final item = _chiTiet[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item['hinhanh'] ?? 'assets/no-image.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item['tensp']),
                    subtitle: Text(
                      'SL: ${item['soluong']} x ${_formatCurrency(item['gia'])}',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
