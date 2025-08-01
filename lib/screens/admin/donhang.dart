
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/screens/admin/chitietdonhang.dart';

class DonHangAdminScreen extends StatefulWidget {
  const DonHangAdminScreen({Key? key}) : super(key: key);

  @override
  _DonHangAdminScreenState createState() => _DonHangAdminScreenState();
}

class _DonHangAdminScreenState extends State<DonHangAdminScreen> {
  List<Map<String, dynamic>> _donHangs = [];
  String _selectedStatus = 'Tất cả';
  String _searchKeyword = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _statusList = [
    'Tất cả',
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang xử lý',
    'Chờ thanh toán',
    'Đã thanh toán',
    'Đang giao',
    'Hoàn tất',
    'Đã hoàn tiền',
    'Không thành công',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    _loadDonHangs();
  }

  Future<void> _loadDonHangs() async {
    final data = await DBHelper().getDonHangsFiltered(_selectedStatus, _searchKeyword);
    setState(() {
      _donHangs = data;
    });
  }


  void lamMoi() {
    setState(() {
      _selectedStatus = 'Tất cả';
      _searchController.clear();
    });
    _loadDonHangs();
  }
  Future<void> _updateTrangThai(int iddh, String newStatus) async {
    await DBHelper().updateTrangThaiDonHang(iddh, newStatus);
    _loadDonHangs();
  }

  String _formatDate(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }

  String _formatCurrency(dynamic amount) {
    try {
      return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
    } catch (_) {
      return '$amount₫';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange.shade100;
      case 'Đã xác nhận':
        return Colors.orange.shade200;
      case 'Đang xử lý':
        return Colors.amber.shade100;
      case 'Chờ thanh toán':
        return Colors.yellow.shade200;
      case 'Đã thanh toán':
        return Colors.green.shade200;
      case 'Đang giao':
        return Colors.blue.shade100;
      case 'Hoàn tất':
        return Colors.green.shade100;
      case 'Đã hoàn tiền':
        return Colors.purple.shade100;
      case 'Không thành công':
        return Colors.black12;
      case 'Đã hủy':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên hoặc mã đơn',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                _searchKeyword = value;
                _loadDonHangs();
              },
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0), // chỉnh padding nếu cần
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statusList
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                    _loadDonHangs();
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Trạng thái',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true, // giúp giảm chiều cao khung
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> donhang) {
    final bgColor = _getStatusColor(donhang['trangthai']);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.receipt_long_rounded, color: Colors.indigo),
        title: Text(
          'Mã đơn: ${donhang['iddh']} - ${donhang['tennguoidat']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ngày đặt: ${_formatDate(donhang['ngaydat'])}'),
              Text('Tổng tiền: ${_formatCurrency(donhang['tongtien'])}'),
              Text('Thanh toán: ${donhang['phuongthucthanhtoan'] ?? ''}'),
              const SizedBox(height: 4),
              Text(
                'Trạng thái:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
              DropdownButton<String>(
                value: donhang['trangthai'],
                isExpanded: true,
                items: _statusList
                    .where((s) => s != 'Tất cả')
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    _updateTrangThai(donhang['iddh'], newStatus);
                  }
                },
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChiTietDonHangScreen(iddh: donhang['iddh']),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          _buildFilterBar(),
          const SizedBox(height: 8),
          Expanded(
            child: _donHangs.isEmpty
                ? const Center(child: Text('Không có đơn hàng nào'))
                : ListView.builder(
              itemCount: _donHangs.length,
              itemBuilder: (context, index) => _buildOrderCard(_donHangs[index]),
            ),
          ),
        ],
      ),
    );
  }
}
