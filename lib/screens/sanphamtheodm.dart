// // import 'package:flutter/material.dart';
// // import '../database/db_helper.dart';
// // import '../models/product_model.dart';
// //
// // class CategoryProductScreen extends StatefulWidget {
// //   final int categoryId;
// //   final String categoryName;
// //
// //   const CategoryProductScreen({
// //     super.key,
// //     required this.categoryId,
// //     required this.categoryName,
// //   });
// //
// //   @override
// //   State<CategoryProductScreen> createState() => _CategoryProductScreenState();
// // }
// //
// // class _CategoryProductScreenState extends State<CategoryProductScreen> {
// //   List<SanPham> _products = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadProducts();
// //   }
// //
// //   Future<void> _loadProducts() async {
// //     final db = DBHelper();
// //     final products = await db.searchSanPhams(danhMucId: widget.categoryId);
// //     setState(() {
// //       _products = products;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Danh mục: ${widget.categoryName}'),
// //       ),
// //       body: _products.isEmpty
// //           ? const Center(child: Text('Không có sản phẩm nào trong danh mục này'))
// //           : GridView.builder(
// //         padding: const EdgeInsets.all(8),
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 8,
// //           mainAxisSpacing: 8,
// //           childAspectRatio: 0.65,
// //         ),
// //         itemCount: _products.length,
// //         itemBuilder: (context, index) {
// //           final product = _products[index];
// //           return Card(
// //             child: Column(
// //               children: [
// //                 Expanded(
// //                   child: Image.asset(
// //                     product.hinhanh ?? 'assets/images/no_image.png',
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Text(product.tensp),
// //                 Text('${product.gia} đ'),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
// import '../models/product_model.dart';
//
// class CategoryProductScreen extends StatefulWidget {
//   final int categoryId;
//   final String categoryName;
//
//   const CategoryProductScreen({
//     super.key,
//     required this.categoryId,
//     required this.categoryName,
//   });
//
//   @override
//   State<CategoryProductScreen> createState() => _CategoryProductScreenState();
// }
//
// class _CategoryProductScreenState extends State<CategoryProductScreen> {
//   List<SanPham> _products = [];
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }
//
//   Future<void> _loadProducts() async {
//     final db = DBHelper();
//     final products = await db.searchSanPhams(danhMucId: widget.categoryId);
//     setState(() {
//       _products = products;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh mục: ${widget.categoryName}'),
//       ),
//       body: _products.isEmpty
//           ? const Center(
//         child: Text('Không có sản phẩm nào trong danh mục này'),
//       )
//       return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.43,
//       ),
//       itemCount: flashSaleProducts.length,
//       itemBuilder: (context, index) {
//         final product = flashSaleProducts[index];
//
//         // Tính giá khuyến mãi
//         // final double price = product.gia;
//         // final double originalPrice = (product.giamgia > 0)
//         //     ? price / (1 - product.giamgia / 100)
//         //     : price;
//         // final int discountPercent =
//         // (product.giamgia > 0) ? product.giamgia.round() : 0;
//         //
//         final double price = product.gia;
//         final int discountPercent = (product.giamgia > 0) ? product.giamgia.round() : 0;
//         final double discountedPrice = (discountPercent > 0)
//             ? price * (1 - discountPercent / 100)
//             : price;
//
//         Future<void> _muaNgay(SanPham product) async {
//           await DBHelper().addToGioHang(widget.iduser, product.idsp!);
//
//           // Hiển thị thông báo SnackBar
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Đã thêm sản phẩm vào giỏ hàng!'),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//
//
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProductDetailScreen(
//                   productId: product.idsp!,
//                   iduser: widget.iduser, // Truyền đúng iduser thay vì null
//                 ),
//               ),
//             );
//           },
//
//
//           child: Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Hình ảnh sản phẩm
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//                     child: Image.asset(
//                       product.hinhanh ?? '',
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//
//                 // Tên sản phẩm
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: Text(
//                     product.tensp,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 // Giá sản phẩm
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Giá sau giảm
//                       Text(
//                         _formatCurrency(discountedPrice),
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//
//
//
//                       // Giá gốc + phần trăm giảm
//                       if (discountPercent > 0)
//                         Row(
//                           children: [
//                             Text(
//                               _formatCurrency(price),
//
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             Container(
//                               padding:
//                               const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 "-$discountPercent%",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//
//                 // Nút mua ngay
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: ElevatedButton(
//                     onPressed: () async => await _muaNgay(product),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(30),
//                       backgroundColor: Colors.orange,
//                     ),
//                     child: const Text(
//                       'Mua ngay',
//                       style: TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//
//       },
//     );
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/screens/chitietsp.dart';
import '../database/db_helper.dart';
import '../models/product_model.dart';

class CategoryProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final int iduser; // Truyền thêm iduser cho giỏ hàng

  const CategoryProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.iduser,
  });

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  List<SanPham> _products = [];

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final db = DBHelper();
    final products = await db.searchSanPhams(danhMucId: widget.categoryId);
    setState(() {
      _products = products;
    });
  }

  Future<void> _muaNgay(SanPham product) async {
    await DBHelper().addToGioHang(widget.iduser, product.idsp!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thêm sản phẩm vào giỏ hàng!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Text('Danh mục: ${widget.categoryName}'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _products.isEmpty
          ? const Center(
        child: Text('Không có sản phẩm nào trong danh mục này'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
          childAspectRatio: 0.43,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];

          // Tính giảm giá
          final double price = product.gia;
          final int discountPercent =
          (product.giamgia > 0) ? product.giamgia.round() : 0;
          final double discountedPrice = (discountPercent > 0)
              ? price * (1 - discountPercent / 100)
              : price;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productId: product.idsp!,
                    iduser: widget.iduser,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.asset(
                        product.hinhanh ?? 'assets/images/no_image.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      product.tensp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatCurrency(discountedPrice),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        if (discountPercent > 0)
                          Row(
                            children: [
                              Text(
                                _formatCurrency(price),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 4),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () async => await _muaNgay(product),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        'Mua ngay',
                        style:
                        TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
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
