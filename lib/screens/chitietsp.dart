import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../database/db_helper.dart';
import 'giohang_screen.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final int? iduser;

  const ProductDetailScreen({
    super.key,
    required this.productId,
     this.iduser,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  SanPham? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final db = DBHelper();
    final sp = await db.getSanPhamById(widget.productId);
    setState(() {
      product = sp;
      isLoading = false;
    });
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
          ? const Center(child: Text('Không tìm thấy sản phẩm'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm lớn
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (product!.hinhanh != null &&
                    product!.hinhanh!.isNotEmpty)
                    ? (product!.hinhanh!.startsWith('http')
                    ? Image.network(
                  product!.hinhanh!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Image.asset(
                      'assets/no-image.png',
                      height: 300,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Image.asset(
                  product!.hinhanh!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ))
                    : Image.asset(
                  'assets/no-image.png',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tên sản phẩm
            Text(
              product!.tensp,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Giá
            Text(
              "Giá: ${_formatCurrency(product!.gia)}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Mô tả
            Text(
              "Mô tả: ${product!.mota ?? 'Không có'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Xuất xứ
            Text(
              "Xuất xứ: ${product!.xuatxu ?? 'Không rõ'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Khối lượng
            Text(
              "Khối lượng: ${product!.khoiluong ?? '-'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Thương hiệu
            Text(
              "Thương hiệu: ${product!.thuonghieu ?? '-'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Số lượng tồn kho
            Text(
              "Số lượng còn: ${product!.soluong}",
              style: const TextStyle(
                  fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(height: 8),

            // Giảm giá
            if (product!.giamgia > 0)
              Text(
                "Giảm giá: ${product!.giamgia.toStringAsFixed(0)}%",
                style: const TextStyle(
                    fontSize: 16, color: Colors.green),
              ),
            const SizedBox(height: 80), // Chừa khoảng cho nút mua
          ],
        ),
      ),

      // Thanh dưới cùng với nút "Mua ngay"
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              if (widget.iduser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bạn cần đăng nhập để thêm vào giỏ hàng!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await DBHelper().addToGioHang(widget.iduser!, product!.idsp!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã thêm sản phẩm vào giỏ hàng!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GioHangScreen(iduser: widget.iduser!),
                ),
              );
            },

            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text(
              'MUA NGAY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
