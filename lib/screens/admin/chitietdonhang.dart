import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

class ChiTietDonHangScreen extends StatefulWidget {
  final int iddh;
  final bool isAdmin; // Thêm tham số để biết Admin hay User

  const ChiTietDonHangScreen({
    super.key,
    required this.iddh,
    this.isAdmin = false, // Mặc định không phải admin
  });

  @override
  State<ChiTietDonHangScreen> createState() => _ChiTietDonHangScreenState();
}

class _ChiTietDonHangScreenState extends State<ChiTietDonHangScreen> {
  List<Map<String, dynamic>> _chiTiet = [];
  String? _selectedStatus; // Trạng thái được chọn
  final List<String> _trangThaiList = ['Chờ xác nhận', 'Đang giao', 'Hoàn tất', 'Hủy'];

  @override
  void initState() {
    super.initState();
    _loadChiTiet();
    _loadTrangThai();
  }

  Future<void> _loadChiTiet() async {
    final db = DBHelper();
    final data = await db.getChiTietDonHang(widget.iddh);
    setState(() {
      _chiTiet = data;
    });
  }

  Future<void> _loadTrangThai() async {
    final db = DBHelper();
    final order = await db.getDonHangById(widget.iddh);
    if (order != null) {
      String currentStatus = order['trangthai'].toString().trim();
      setState(() {
        _selectedStatus = _trangThaiList.contains(currentStatus)
            ? currentStatus
            : _trangThaiList[0];
      });
    }
  }

  Future<void> _updateTrangThai() async {
    if (_selectedStatus == null) return;

    final db = DBHelper();
    await db.updateTrangThaiDonHang(widget.iddh, _selectedStatus!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật trạng thái thành công!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng mã ${widget.iddh}'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Dropdown trạng thái (chỉ hiển thị nếu Admin)
          if (widget.isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Trạng thái:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      isExpanded: true,
                      items: _trangThaiList.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateTrangThai,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Lưu'),
                  ),
                ],
              ),
            ),
          const Divider(),
          Expanded(
            child: _chiTiet.isEmpty
                ? const Center(child: Text('Không có chi tiết đơn hàng.'))
                : ListView.builder(
              itemCount: _chiTiet.length,
              itemBuilder: (context, index) {
                final item = _chiTiet[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset(
                      item['hinhanh'] ?? 'assets/no-image.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['tensp']),
                    subtitle: Text(
                        'SL: ${item['soluong']} x ${item['gia']} đ'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
