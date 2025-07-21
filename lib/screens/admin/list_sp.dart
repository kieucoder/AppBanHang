import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/product_model.dart';
import 'package:shopbanhang/screens/admin/crud_sp.dart';
import 'package:shopbanhang/screens/admin/detail_sp.dart';

class ListSanPhamScreen extends StatefulWidget {
  const ListSanPhamScreen({super.key});

  @override
  State<ListSanPhamScreen> createState() => _ListSanPhamScreenState();
}

class _ListSanPhamScreenState extends State<ListSanPhamScreen> {
  List<SanPham> _sanPhams = [];
  final DBHelper _db = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadSanPhams();
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  Future<void> _loadSanPhams() async {
    final data = await _db.getAllSanPhams();
    setState(() {
      _sanPhams = data;
    });
  }

  Future<void> _deleteSanPham(int id) async {
    final sanpham = _sanPhams.firstWhere((sp) => sp.idsp == id);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa sản phẩm "${sanpham.tensp}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deleteSanPham(id);
      _loadSanPhams();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm "${sanpham.tensp}" đã bị xóa')),
      );
    }
  }

  Future<void> _editSanPham(SanPham sp) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditSanPhamScreen(sanPham: sp)),
    );
    if (result == true) _loadSanPhams();
  }

  Future<void> _addSanPham() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditSanPhamScreen()),
    );
    if (result == true) _loadSanPhams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSanPham, // Bấm để thêm sản phẩm mới
          ),
        ],
      ),
      body: _sanPhams.isEmpty
          ? const Center(child: Text('Chưa có sản phẩm'))
          : ListView.builder(
        itemCount: _sanPhams.length,
        itemBuilder: (context, index) {
          final sp = _sanPhams[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              leading: sp.hinhanh != null && sp.hinhanh!.isNotEmpty
                  ? Image.asset(
                sp.hinhanh!,
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) => const Icon(Icons.image),
              )
                  : const Icon(Icons.image),
              title: Text(sp.tensp),
              subtitle: Text('Giá: ${_formatCurrency(sp.gia)} - Giảm giá: ${sp.giamgia}%'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SanPhamDetailScreen(sanPham: sp)),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editSanPham(sp),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteSanPham(sp.idsp!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
