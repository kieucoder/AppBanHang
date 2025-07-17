import 'package:flutter/material.dart';
import 'package:shopbanhang/main.dart';
import '../database/db_helper.dart';



class DanhSachDanhMucScreen extends StatefulWidget {
  const DanhSachDanhMucScreen({super.key});

  @override
  State<DanhSachDanhMucScreen> createState() => _DanhSachDanhMucScreenState();
}

class _DanhSachDanhMucScreenState extends State<DanhSachDanhMucScreen> {
  List<Map<String, dynamic>> _danhMucList = [];

  @override
  void initState() {
    super.initState();
    _loadDanhMuc();
  }

  Future<void> _loadDanhMuc() async {
    final data = await DBHelper.getDanhMucList();
    // final data = await DBHelper.getDanhMucList();
    setState(() {
      _danhMucList = data.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách danh mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDanhMuc, // làm mới danh sách
          ),
        ],
      ),
      body: _danhMucList.isEmpty
          ? const Center(child: Text('Chưa có danh mục nào!'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _danhMucList.length,
        itemBuilder: (context, index) {
          final dm = _danhMucList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.category, color: Colors.deepOrange),
              title: Text(dm['tendanhmuc']),
              subtitle: Text('Trạng thái: ${dm['trangthai'] ?? 'Không rõ'}'),
            ),
          );
        },
      ),
    );
  }
}
