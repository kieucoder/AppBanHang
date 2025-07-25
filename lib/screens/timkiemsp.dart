
import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/chitietsp.dart';
import '../database/db_helper.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class SearchProductScreen extends StatefulWidget {
  final int? iduser;

  const SearchProductScreen({super.key, this.iduser});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SanPham> _searchResults = [];



  // Định dạng VNĐ
  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  Future<void> _searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }
    final db = DBHelper();
    final results = await db.searchSanPhams(keyword: keyword,trangThai: 'Hiện');
    setState(() {
      _searchResults = results;
    });
  }

  void _goToProductDetail(SanPham product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productId: product.idsp!,
          iduser: widget.iduser ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('Không có sản phẩm nào'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ListTile(
            leading: Image.asset(
              product.hinhanh ?? 'assets/images/no_image.png',
              width: 60,
              fit: BoxFit.cover,
            ),
            title: Text(product.tensp,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${_formatCurrency(product.gia)}",
                style: const TextStyle(color: Colors.red)),
            onTap: () => _goToProductDetail(product),
          );
        },
      ),
    );
  }
}
