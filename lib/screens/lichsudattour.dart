
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

  // Future<void> _huyDonHang(int iddh) async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Xác nhận hủy đơn'),
  //       content: const Text('Bạn có chắc muốn hủy đơn hàng này không?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Không'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text('Có', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (confirm == true) {
  //     await DBHelper().updateTrangThaiDonHang(iddh, 'Đã hủy');
  //     await _loadLichSu();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Đơn hàng đã được hủy!')),
  //     );
  //   }
  // }
  Future<void> _huyDonHang(int iddh, String trangThai) async {
    if (trangThai != 'Chờ xác nhận') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ được hủy đơn khi đang ở trạng thái "Chờ xác nhận"'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
            child: const Text('Có', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper().updateTrangThaiDonHang(iddh, 'Đã hủy');
      await _loadLichSu();
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


  //hàm màu sắc dựa trên trạng thái đơn hàng
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange; // Màu vàng cam
      case 'Đang giao':
        return Colors.blue; // Màu xanh dương
      case 'Hoàn tất':
        return Colors.green; // Màu xanh lá
      case 'Đã hủy':
        return Colors.red; // Màu đỏ
      default:
        return Colors.grey; // Mặc định
    }
  }



  String _formatNgay(String ngay) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(ngay));
    } catch (e) {
      return ngay;
    }
  }

  String _formatCurrency(double price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        title: const Text('Lịch sử đặt tour'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: _lichSu.isEmpty
          ? const Center(
        child: Text(
          'Chưa có đơn hàng nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _lichSu.length,
        itemBuilder: (context, index) {
          final order = _lichSu[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child:
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Mã ĐH: ${order['iddh']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ngày đặt: ${_formatNgay(order['ngaydat'])}'),
                    Text(
                      'Tổng tiền: ${_formatCurrency(order['tongtien'])}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Trạng thái: ${order['trangthai']}',
                      style: TextStyle(
                        color: order['trangthai'] == 'Đã hủy'
                            ? Colors.red
                            : order['trangthai'] == 'Chờ xác nhận'
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                // Danh sách sản phẩm trong đơn hàng
                ...List.generate(order['chitiet'].length, (i) {
                  final sp = order['chitiet'][i];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        sp['hinhanh'] ?? 'assets/no-image.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(sp['tensp']),
                    subtitle: Text(
                      'SL: ${sp['soluong']} x ${_formatCurrency(sp['gia'])}',
                    ),
                  );
                }),

                // Nút Hủy đơn hàng (chỉ khi trạng thái là Chờ xác nhận)
                if (order['trangthai'] == 'Chờ xác nhận')
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton.icon(
                      onPressed: () => _huyDonHang(order['iddh'], order['trangthai']),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text('Hủy đơn hàng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            )




          );
        },
      ),
    );
  }
}

