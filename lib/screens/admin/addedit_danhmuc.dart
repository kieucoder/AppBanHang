// import 'package:flutter/material.dart';
// import 'package:shopbanhang/database/db_helper.dart';
// import 'package:shopbanhang/models/danhmuc.dart';
//
// class ThemDanhMucScreen extends StatefulWidget {
//   final DanhMuc? danhMuc; // <- thêm thuộc tính này
//
//   const ThemDanhMucScreen({super.key, this.danhMuc}); // <- gán vào constructor
//
//   @override
//   State<ThemDanhMucScreen> createState() => _ThemDanhMucScreenState();
// }
//
//
//
//
// class _ThemDanhMucScreenState extends State<ThemDanhMucScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _tenController = TextEditingController();
//   final TextEditingController _hinhAnhController = TextEditingController();
//   String _trangThai = 'Hiển thị';
//
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.danhMuc != null) {
//       _tenController.text = widget.danhMuc!.tendanhmuc;
//       _hinhAnhController.text = widget.danhMuc!.hinhanh ?? '';
//       _trangThai = widget.danhMuc!.trangthai ?? 'Hiển thị';
//     }
//   }
//
//
//   Future<void> _luuDanhMuc() async {
//     if (_formKey.currentState!.validate()) {
//       String ten = _tenController.text.trim();
//       String hinhAnh = _hinhAnhController.text.trim();
//
//       final danhMucMoi = DanhMuc(
//         id: widget.danhMuc?.id,
//         tendanhmuc: ten,
//         trangthai: _trangThai,
//         hinhanh: hinhAnh,
//       );
//
//       int id;
//       if (widget.danhMuc == null) {
//         id = await DBHelper().insertDanhMuc(danhMucMoi);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Thêm danh mục thành công! ID: $id')),
//         );
//       } else {
//         await DBHelper().updateDanhMuc(danhMucMoi);
//         id = danhMucMoi.id!;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Cập nhật danh mục ID: $id thành công!')),
//         );
//       }
//
//       Future.delayed(const Duration(seconds: 1), () {
//         Navigator.pop(context, true);
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Thêm danh mục')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _tenController,
//                 decoration: const InputDecoration(labelText: 'Tên danh mục'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập tên danh mục';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _hinhAnhController,
//                 decoration: const InputDecoration(
//                   labelText: 'Đường dẫn hình ảnh (VD: assets/hipplogo.png)',
//                 ),
//                 onChanged: (_) => setState(() {}),
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: _hinhAnhController.text.trim().isNotEmpty
//                     ? Image.asset(
//                   _hinhAnhController.text.trim(),
//                   height: 120,
//                   errorBuilder: (context, error, stackTrace) =>
//                   const Text('Không tìm thấy hình ảnh'),
//                 )
//                     : const Text('Chưa có hình ảnh'),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _trangThai,
//                 decoration: const InputDecoration(labelText: 'Trạng thái'),
//                 items: ['Hiển thị', 'Ẩn'].map((trangThai) {
//                   return DropdownMenuItem(
//                     value: trangThai,
//                     child: Text(trangThai),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _trangThai = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _luuDanhMuc,
//                   child: const Text('Lưu danh mục'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/danhmuc.dart';

class ThemDanhMucScreen extends StatefulWidget {
  final DanhMuc? danhMuc; // Nếu null => thêm mới, ngược lại => sửa

  const ThemDanhMucScreen({super.key, this.danhMuc});

  @override
  State<ThemDanhMucScreen> createState() => _ThemDanhMucScreenState();
}

class _ThemDanhMucScreenState extends State<ThemDanhMucScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _hinhAnhController = TextEditingController();
  String _trangThai = 'Hiển thị';

  @override
  void initState() {
    super.initState();
    if (widget.danhMuc != null) {
      _tenController.text = widget.danhMuc!.tendanhmuc;
      _hinhAnhController.text = widget.danhMuc!.hinhanh ?? '';
      _trangThai = widget.danhMuc!.trangthai ?? 'Hiển thị';
    }
  }

  Future<void> _luuDanhMuc() async {
    if (_formKey.currentState!.validate()) {
      final danhMucMoi = DanhMuc(
        id: widget.danhMuc?.id,
        tendanhmuc: _tenController.text.trim(),
        trangthai: _trangThai,
        hinhanh: _hinhAnhController.text.trim(),
      );

      if (widget.danhMuc == null) {
        int id = await DBHelper().insertDanhMuc(danhMucMoi);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm danh mục thành công! ID: $id')),
        );
      } else {
        await DBHelper().updateDanhMuc(danhMucMoi);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật danh mục thành công!')),
        );
      }
      Navigator.pop(context, true); // Trả về true để List reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.danhMuc == null ? 'Thêm danh mục' : 'Sửa danh mục'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tenController,
                decoration: const InputDecoration(labelText: 'Tên danh mục'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên danh mục' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hinhAnhController,
                decoration: const InputDecoration(
                  labelText: 'Đường dẫn hình ảnh (VD: assets/hipplogo.png)',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Center(
                child: _hinhAnhController.text.trim().isNotEmpty
                    ? Image.asset(
                  _hinhAnhController.text.trim(),
                  height: 120,
                  errorBuilder: (context, error, stackTrace) =>
                  const Text('Không tìm thấy hình ảnh'),
                )
                    : const Text('Chưa có hình ảnh'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _trangThai,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                items: ['Hiển thị', 'Ẩn'].map((trangThai) {
                  return DropdownMenuItem(
                    value: trangThai,
                    child: Text(trangThai),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _trangThai = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _luuDanhMuc,
                  child: Text(widget.danhMuc == null ? 'Thêm danh mục' : 'Cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

