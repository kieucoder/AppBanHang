import 'package:flutter/material.dart';
import 'package:shopbanhang/models/product_model.dart';

class SanPhamDetailScreen extends StatelessWidget {
  final SanPham sanPham;
  const SanPhamDetailScreen({super.key, required this.sanPham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết: ${sanPham.tensp}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: sanPham.hinhanh != null && sanPham.hinhanh!.isNotEmpty
                  ? Image.asset(
                sanPham.hinhanh!,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 80),
              )
                  : const Icon(Icons.image, size: 80),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  const TextSpan(
                    text: 'Tên sản phẩm: ',
                    style: TextStyle(fontWeight: FontWeight.bold), // Tô đậm tiêu đề
                  ),
                  TextSpan(
                    text: sanPham.tensp, // Tên sản phẩm giữ kiểu chữ thường
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text('Giá: ${sanPham.gia} VNĐ', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Giảm giá: ${sanPham.giamgia} %', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Mô tả: ${sanPham.mota ?? "Chưa có"}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Thương hiệu: ${sanPham.thuonghieu ?? "N/A"}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Xuất xứ: ${sanPham.xuatxu ?? "N/A"}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Khối lượng: ${sanPham.khoiluong ?? "N/A"}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Số lượng: ${sanPham.soluong}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Trạng thái: ${sanPham.trangthai}'),
            const SizedBox(height: 8,),
            Text('Danh mục ID: ${sanPham.iddanhmuc ?? "N/A"}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
