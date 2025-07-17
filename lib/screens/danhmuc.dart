import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

class ThemDanhMucScreen extends StatefulWidget {
  const ThemDanhMucScreen({super.key});

  @override
  State<ThemDanhMucScreen> createState() => _ThemDanhMucScreenState();
}

class _ThemDanhMucScreenState extends State<ThemDanhMucScreen> {
  final TextEditingController _tenDanhMucController = TextEditingController();
  String _trangThai = "Hiện";

  Future<void> _luuDanhMuc() async {
    String ten = _tenDanhMucController.text.trim();

    if (ten.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Vui lòng nhập tên danh mục")),
      );
      return;
    }

    await DBHelper.insertDanhMucSP({
      'tendanhmuc': ten,
      'trangthai': _trangThai,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Đã thêm "$ten" thành công')),
    );

    _tenDanhMucController.clear();
    setState(() {
      _trangThai = "Hiện";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('➕ Thêm danh mục')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tenDanhMucController,
              decoration: const InputDecoration(
                labelText: 'Tên danh mục',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _trangThai,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Hiện', child: Text('Hiện')),
                DropdownMenuItem(value: 'Ẩn', child: Text('Ẩn')),
              ],
              onChanged: (value) {
                setState(() {
                  _trangThai = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _luuDanhMuc,
              icon: const Icon(Icons.save),
              label: const Text("Lưu danh mục"),
            ),
          ],
        ),
      ),
    );
  }
}
