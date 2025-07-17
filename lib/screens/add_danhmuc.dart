import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ThemDanhMucScreen extends StatefulWidget {
  const ThemDanhMucScreen({super.key});

  @override
  State<ThemDanhMucScreen> createState() => _ThemDanhMucScreenState();
}

class _ThemDanhMucScreenState extends State<ThemDanhMucScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenDanhMucController = TextEditingController();
  String _trangThai = 'Hiện';

  Future<void> _luuDanhMuc() async {
    if (_formKey.currentState!.validate()) {
      final newDanhMuc = {
        'tendanhmuc': _tenDanhMucController.text.trim(),
        'trangthai': _trangThai,
      };

      await DBHelper.insertDanhMucSP(newDanhMuc);

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm danh mục thành công!')),
      );

      // Xóa nội dung sau khi lưu
      _tenDanhMucController.clear();
      setState(() {
        _trangThai = 'Hiện';
      });
    }
  }

  @override
  void dispose() {
    _tenDanhMucController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tenDanhMucController,
                decoration: const InputDecoration(
                  labelText: 'Tên danh mục',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _trangThai,
                items: const [
                  DropdownMenuItem(value: 'Hiện', child: Text('Hiện')),
                  DropdownMenuItem(value: 'Ẩn', child: Text('Ẩn')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _trangThai = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _luuDanhMuc,
                  child: const Text('Lưu danh mục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
