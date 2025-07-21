
import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/danhmuc.dart';
import 'package:shopbanhang/screens/admin/addedit_danhmuc.dart';

class ListDanhMucScreen extends StatefulWidget {
  const ListDanhMucScreen({super.key});

  @override
  State<ListDanhMucScreen> createState() => _ListDanhMucScreenState();
}

class _ListDanhMucScreenState extends State<ListDanhMucScreen> {
  List<DanhMuc> _danhMucs = [];
  final DBHelper _db = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadDanhMucs();
  }

  Future<void> _loadDanhMucs() async {
    final data = await _db.getDanhMucs();
    setState(() {
      _danhMucs = data.map((e) => DanhMuc.fromMap(e)).toList();
    });
  }



  Future<void> _deleteDanhMuc(int id) async {
    final danhMuc = _danhMucs.firstWhere((dm) => dm.id == id);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa danh mục "${danhMuc.tendanhmuc}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deleteDanhMuc(id);
      _loadDanhMucs();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Danh mục "${danhMuc.tendanhmuc}" đã bị xóa')),
      );
    }
  }






  Future<void> _editDanhMuc(DanhMuc dm) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemDanhMucScreen(danhMuc: dm),
      ),
    );
    if (result == true) _loadDanhMucs();
  }

  Future<void> _addDanhMuc() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ThemDanhMucScreen(),
      ),
    );
    if (result == true) _loadDanhMucs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý danh mục'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDanhMuc,
          ),
        ],
      ),
      body: _danhMucs.isEmpty
          ? const Center(child: Text('Chưa có danh mục'))
          : ListView.builder(
        itemCount: _danhMucs.length,
        itemBuilder: (context, index) {
          final dm = _danhMucs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              leading: dm.hinhanh != null && dm.hinhanh!.isNotEmpty
                  ? Image.asset(
                dm.hinhanh!,
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) => const Icon(Icons.image),
              )
                  : const Icon(Icons.image),
              title: Text(dm.tendanhmuc),
              subtitle: Text('Trạng thái: ${dm.trangthai ?? 'N/A'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editDanhMuc(dm),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDanhMuc(dm.id!),
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

