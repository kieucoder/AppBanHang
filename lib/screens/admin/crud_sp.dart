
//
// import 'package:flutter/material.dart';
// import 'package:shopbanhang/database/db_helper.dart';
// import 'package:shopbanhang/models/product_model.dart';
// import 'package:shopbanhang/models/danhmuc.dart';
// import 'package:intl/intl.dart';   // để chuyển đổi tiền vnđ
//
//
//
// class AddEditSanPhamScreen extends StatefulWidget {
//   final SanPham? sanPham;
//   const AddEditSanPhamScreen({super.key, this.sanPham});
//
//   @override
//   State<AddEditSanPhamScreen> createState() => _AddEditSanPhamScreenState();
// }
//
// class _AddEditSanPhamScreenState extends State<AddEditSanPhamScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _tenController = TextEditingController();
//   final TextEditingController _moTaController = TextEditingController();
//   final TextEditingController _giaController = TextEditingController();
//   final TextEditingController _hinhAnhController = TextEditingController();
//   final TextEditingController _xuatXuController = TextEditingController();
//   final TextEditingController _khoiLuongController = TextEditingController();
//   final TextEditingController _thuongHieuController = TextEditingController();
//   final TextEditingController _soLuongController = TextEditingController();
//   final TextEditingController _giamGiaController = TextEditingController();
//
//   List<DanhMuc> _danhMucs = [];
//   int? _selectedDanhMuc;
//   final NumberFormat _currencyFormatter = NumberFormat('#,###', 'vi_VN');
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDanhMucs();
//     if (widget.sanPham != null) {
//       final sp = widget.sanPham!;
//       _tenController.text = sp.tensp;
//       _moTaController.text = sp.mota ?? '';
//       _giaController.text = _currencyFormatter.format(sp.gia);
//       _hinhAnhController.text = sp.hinhanh ?? '';
//       _xuatXuController.text = sp.xuatxu ?? '';
//       _khoiLuongController.text = sp.khoiluong ?? '';
//       _thuongHieuController.text = sp.thuonghieu ?? '';
//       _soLuongController.text = sp.soluong.toString();
//       _giamGiaController.text = sp.giamgia.toString();
//       _selectedDanhMuc = sp.iddanhmuc;
//     }
//   }
//
//   Future<void> _loadDanhMucs() async {
//     final data = await DBHelper().getDanhMucs();
//     setState(() {
//       _danhMucs = data.map((e) => DanhMuc.fromMap(e)).toList();
//     });
//   }
//
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: const OutlineInputBorder(),
//     );
//   }
//
//   Future<void> _saveSanPham() async {
//     if (_formKey.currentState!.validate()) {
//
//       final giaValue = _giaController.text.replaceAll('.', '').replaceAll(',', '').trim();
//       final giamGiaValue = _giamGiaController.text.trim();
//       final sp = SanPham(
//         idsp: widget.sanPham?.idsp,
//         tensp: _tenController.text.trim(),
//         mota: _moTaController.text.trim(),
//         gia: double.tryParse(giaValue) ?? 0,
//         hinhanh: _hinhAnhController.text.trim(),
//         xuatxu: _xuatXuController.text.trim(),
//         khoiluong: _khoiLuongController.text.trim(),
//         thuonghieu: _thuongHieuController.text.trim(),
//         soluong: int.tryParse(_soLuongController.text.trim()) ?? 0,
//         giamgia: double.tryParse(_giamGiaController.text.trim()) ?? 0,
//         iddanhmuc: _selectedDanhMuc,
//       );
//
//       final db = DBHelper();
//       if (widget.sanPham == null) {
//         await db.insertSanPham(sp);
//       } else {
//         await db.updateSanPham(sp);
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Lưu sản phẩm thành công')),
//       );
//       Navigator.pop(context, true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.sanPham == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _tenController,
//                 decoration: _inputDecoration('Tên sản phẩm'),
//                 validator: (val) =>
//                 val == null || val.isEmpty ? 'Nhập tên sản phẩm' : null,
//               ),
//               const SizedBox(height: 12),
//               // Ô nhập mô tả lớn hơn
//               SizedBox(
//                 height: 120,
//                 child: TextFormField(
//                   controller: _moTaController,
//                   maxLines: null,
//                   expands: true,
//                   keyboardType: TextInputType.multiline,
//                   decoration: _inputDecoration('Mô tả').copyWith(
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _giaController,
//                 decoration: _inputDecoration('Giá'),
//                 keyboardType: TextInputType.number,
//                 validator: (val) =>
//                 val == null || val.isEmpty ? 'Nhập giá' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _giamGiaController,
//                 decoration: _inputDecoration('Giảm giá (%)'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _hinhAnhController,
//                 decoration: _inputDecoration('Hình ảnh: assats/friso1.png'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _xuatXuController,
//                 decoration: _inputDecoration('Xuất xứ'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _khoiLuongController,
//                 decoration: _inputDecoration('Khối lượng'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _thuongHieuController,
//                 decoration: _inputDecoration('Thương hiệu'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _soLuongController,
//                 decoration: _inputDecoration('Số lượng'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<int>(
//                 value: _selectedDanhMuc,
//                 decoration: _inputDecoration('Danh mục'),
//                 items: _danhMucs
//                     .map((dm) => DropdownMenuItem(
//                   value: dm.id,
//                   child: Text(dm.tendanhmuc),
//                 ))
//                     .toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     _selectedDanhMuc = val;
//                   });
//                 },
//                 validator: (val) =>
//                 val == null ? 'Chọn danh mục' : null,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveSanPham,
//                 child: const Text('Lưu sản phẩm'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/product_model.dart';
import 'package:shopbanhang/models/danhmuc.dart';

class AddEditSanPhamScreen extends StatefulWidget {
  final SanPham? sanPham;
  const AddEditSanPhamScreen({super.key, this.sanPham});

  @override
  State<AddEditSanPhamScreen> createState() => _AddEditSanPhamScreenState();
}

class _AddEditSanPhamScreenState extends State<AddEditSanPhamScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _moTaController = TextEditingController();
  final TextEditingController _giaController = TextEditingController();
  final TextEditingController _hinhAnhController = TextEditingController();
  final TextEditingController _xuatXuController = TextEditingController();
  final TextEditingController _khoiLuongController = TextEditingController();
  final TextEditingController _thuongHieuController = TextEditingController();
  final TextEditingController _soLuongController = TextEditingController();
  final TextEditingController _giamGiaController = TextEditingController();

  List<DanhMuc> _danhMucs = [];
  int? _selectedDanhMuc;

  final NumberFormat _currencyFormatter = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _loadDanhMucs();
    if (widget.sanPham != null) {
      final sp = widget.sanPham!;
      _tenController.text = sp.tensp;
      _moTaController.text = sp.mota ?? '';
      _giaController.text = _currencyFormatter.format(sp.gia);
      _hinhAnhController.text = sp.hinhanh ?? '';
      _xuatXuController.text = sp.xuatxu ?? '';
      _khoiLuongController.text = sp.khoiluong ?? '';
      _thuongHieuController.text = sp.thuonghieu ?? '';
      _soLuongController.text = sp.soluong.toString();
      _giamGiaController.text = sp.giamgia.toString();
      _selectedDanhMuc = sp.iddanhmuc;
    }
  }

  Future<void> _loadDanhMucs() async {
    final data = await DBHelper().getDanhMucs();
    setState(() {
      _danhMucs = data.map((e) => DanhMuc.fromMap(e)).toList();
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final cleanValue = value.replaceAll('.', '').replaceAll(',', '').replaceAll('VNĐ', '').trim();
    final intValue = int.tryParse(cleanValue) ?? 0;
    return _currencyFormatter.format(intValue);
  }

  Future<void> _saveSanPham() async {
    if (_formKey.currentState!.validate()) {
      final giaValue = _giaController.text.replaceAll('.', '').replaceAll(',', '').trim();
      final giamGiaValue = _giamGiaController.text.trim();

      final sp = SanPham(
        idsp: widget.sanPham?.idsp,
        tensp: _tenController.text.trim(),
        mota: _moTaController.text.trim(),
        gia: double.tryParse(giaValue) ?? 0,
        hinhanh: _hinhAnhController.text.trim(),
        xuatxu: _xuatXuController.text.trim(),
        khoiluong: _khoiLuongController.text.trim(),
        thuonghieu: _thuongHieuController.text.trim(),
        soluong: int.tryParse(_soLuongController.text.trim()) ?? 0,
        giamgia: double.tryParse(giamGiaValue) ?? 0,
        iddanhmuc: _selectedDanhMuc,
      );

      final db = DBHelper();
      if (widget.sanPham == null) {
        await db.insertSanPham(sp);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm sản phẩm thành công')),
        );
      } else {
        await db.updateSanPham(sp);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật sản phẩm thành công')),
        );
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sanPham == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tenController,
                decoration: _inputDecoration('Tên sản phẩm'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Nhập tên sản phẩm' : null,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: TextFormField(
                  controller: _moTaController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: _inputDecoration('Mô tả').copyWith(
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _giaController,
                decoration: _inputDecoration('Giá (VNĐ)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final newValue = _formatCurrency(value);
                  _giaController.value = TextEditingValue(
                    text: newValue,
                    selection:
                    TextSelection.collapsed(offset: newValue.length),
                  );
                },
                validator: (val) =>
                val == null || val.isEmpty ? 'Nhập giá' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _giamGiaController,
                decoration: _inputDecoration('Giảm giá (%)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hinhAnhController,
                decoration: _inputDecoration('Hình ảnh: assets/friso1.png'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _xuatXuController,
                decoration: _inputDecoration('Xuất xứ'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _khoiLuongController,
                decoration: _inputDecoration('Khối lượng'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thuongHieuController,
                decoration: _inputDecoration('Thương hiệu'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _soLuongController,
                decoration: _inputDecoration('Số lượng'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedDanhMuc,
                decoration: _inputDecoration('Danh mục'),
                items: _danhMucs
                    .map((dm) => DropdownMenuItem(
                  value: dm.id,
                  child: Text(dm.tendanhmuc),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedDanhMuc = val;
                  });
                },
                validator: (val) => val == null ? 'Chọn danh mục' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSanPham,
                child: const Text('Lưu sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

