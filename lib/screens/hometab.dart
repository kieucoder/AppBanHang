import 'dart:async';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'chitietsp.dart';
import 'giohang_screen.dart'; // Import trang giỏ hàng
import '../models/product_model.dart'; // Import model SanPham

class HomeTab extends StatefulWidget {
  final int iduser; // ID của user đăng nhập
  const HomeTab({Key? key, required this.iduser}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> bannerImages = [
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png',
  ];

  final PageController _bannerController = PageController();
  int _currentPage = 0;
  Timer? _bannerTimer;

  List<Map<String, dynamic>> danhMucs = [];
  List<SanPham> flashSaleProducts = [];

  Future<void> loadSanPhams() async {
    final data = await DBHelper().getAllSanPhams(); // List<SanPham>
    setState(() {
      flashSaleProducts = data;
    });
  }


  @override
  void initState() {
    super.initState();
    _startBannerTimer();
    loadDanhMucs();
    loadSanPhams();

  }



  // Tự động chạy banner
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _bannerController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // Lấy danh mục từ DB
  Future<void> loadDanhMucs() async {
    final data = await DBHelper().getDanhMucs();
    setState(() {
      danhMucs = data;
    });
  }


  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // --- Widget Banner ---
  Widget buildBanner() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: bannerImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                bannerImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Widget Danh mục ---
  Widget buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh mục sản phẩm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: danhMucs.isEmpty
              ? const Center(child: Text('Không có danh mục nào'))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: danhMucs.length,
            itemBuilder: (context, index) {
              final cat = danhMucs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.lightBlue.shade100,
                      backgroundImage: cat['hinhanh'] != null &&
                          cat['hinhanh'].toString().isNotEmpty
                          ? AssetImage(cat['hinhanh'])
                          : null,
                      child: cat['hinhanh'] == null ||
                          cat['hinhanh'].toString().isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['tendanhmuc'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Widget Flash Sale ---
  Widget buildFlashSaleList() {
    if (flashSaleProducts.isEmpty) {
      return const Center(
        child: Text(
          'Không có sản phẩm nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.43,
      ),
      itemCount: flashSaleProducts.length,
      itemBuilder: (context, index) {
        final product = flashSaleProducts[index];

        // Tính giá khuyến mãi
        final double price = product.gia;
        final double originalPrice = (product.giamgia > 0)
            ? price / (1 - product.giamgia / 100)
            : price;
        final int discountPercent =
        (product.giamgia > 0) ? product.giamgia.round() : 0;

        // Hàm xử lý mua ngay
        Future<void> _muaNgay(SanPham product) async {
          await DBHelper().addToGioHang(widget.iduser, product.idsp!);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GioHangScreen(iduser: widget.iduser),
            ),
          );
        }



        return GestureDetector(
          onTap: () {
            // Điều hướng đến trang chi tiết sản phẩm
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productId:product.idsp ?? 1,
                  iduser: widget.iduser,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    (product.hinhanh != null && product.hinhanh!.isNotEmpty)
                        ? product.hinhanh!
                        : 'assets/no-image.png', // Ảnh mặc định
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),

                // Tên sản phẩm
                Text(
                  product.tensp,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Giá bán
                Text(
                  "${price.toStringAsFixed(0)} đ",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                // Giá gốc + phần trăm giảm
                Row(
                  children: [
                    if (discountPercent > 0)
                      Text(
                        "${originalPrice.toStringAsFixed(0)} đ",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 4),
                    if (discountPercent > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "-$discountPercent%",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Số lượng còn lại
                Text(
                  "Còn ${product.soluong} sản phẩm",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),

                // Nút mua hàng
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _muaNgay(product),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text(
                      'Mua ngay',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBanner(),
          const SizedBox(height: 16),
          buildCategoryList(),
          const SizedBox(height: 24),
          buildFlashSaleList(),
        ],
      ),
    );
  }
}
