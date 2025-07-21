import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'home_screens.dart' show HomeScreen;

class ThanhToanScreen extends StatelessWidget {
  final int iduser;
  final String tenKhachHang;
  final String sdt;
  final String diaChi;
  final String ghiChu;
  final double tongTien;
  final String phuongThuc;
  final int iddh; // ID đơn hàng

  const ThanhToanScreen({
    super.key,
    required this.iduser,
    required this.tenKhachHang,
    required this.sdt,
    required this.diaChi,
    required this.ghiChu,
    required this.tongTien,
    required this.phuongThuc,
    required this.iddh,
  });

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận thanh toán'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Đặt hàng thành công!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Mã đơn hàng: $iddh',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Tên khách hàng: $tenKhachHang'),
                  Text('Số điện thoại: $sdt'),
                  Text('Địa chỉ: $diaChi'),
                  if (ghiChu.isNotEmpty) Text('Ghi chú: $ghiChu'),
                  Text('Phương thức: $phuongThuc'),
                  Text(
                    'Tổng tiền: ${_formatCurrency(tongTien)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(iduser: iduser, username: tenKhachHang),
                          ),
                              (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Quay về Trang chủ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
