
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/models/product_model.dart';
import 'package:shopbanhang/screens/admin/crud_sp.dart';
import 'package:shopbanhang/screens/admin/detail_sp.dart';

class ListSanPhamScreen extends StatefulWidget {
  const ListSanPhamScreen({super.key});

  @override
  State<ListSanPhamScreen> createState() => _ListSanPhamScreenState();
}

class _ListSanPhamScreenState extends State<ListSanPhamScreen> {
  final DBHelper _db = DBHelper();
  final TextEditingController _searchController = TextEditingController();
  List<SanPham> _sanPhams = [];
  List<Map<String, dynamic>> _danhMucs = [];
  int? _selectedDanhMuc;
  String? _selectTrangThai;

  @override
  void initState() {
    super.initState();
    _loadSanPhams();
    _loadDanhMucs();
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  Future<void> _loadDanhMucs() async {
    final data = await _db.getDanhMucs();
    setState(() {
      _danhMucs = data;
    });
  }

  Future<void> _loadSanPhams() async {
    final data = await _db.searchSanPhams(
      keyword: _searchController.text,
      danhMucId: _selectedDanhMuc,
      trangThai: _selectTrangThai,
    );
    setState(() {
      _sanPhams = data;
    });
  }

  Future<void> _deleteSanPham(int id) async {
    final sanpham = _sanPhams.firstWhere((sp) => sp.idsp == id);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa sản phẩm "${sanpham.tensp}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deleteSanPham(id);
      _loadSanPhams();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm "${sanpham.tensp}" đã bị xóa')),
      );
    }
  }

  Future<void> _editSanPham(SanPham sp) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditSanPhamScreen(sanPham: sp)),
    );
    if (result == true) _loadSanPhams();
  }

  Future<void> _addSanPham() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditSanPhamScreen()),
    );
    if (result == true) _loadSanPhams();
  }



  List<DropdownMenuItem<int?>> getDanhMucItems() {
    // Tạo danh sách và thêm mục "Tất cả danh mục" trước
    List<DropdownMenuItem<int?>> items = [
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('Tất cả danh mục'),
      ),
    ];

    // Thêm các danh mục từ _danhMucs
    for (var dm in _danhMucs) {
      items.add(
        DropdownMenuItem<int?>(
          value: dm['id'] as int,
          child: Text(dm['tendanhmuc'] as String),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ==== BỘ LỌC ====
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Ô tìm kiếm
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => _loadSanPhams(),
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<int?>(
                  value: _selectedDanhMuc,
                  hint: const Text('Chọn danh mục'),
                  onChanged: (value) {
                    setState(() => _selectedDanhMuc = value);
                    _loadSanPhams();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: getDanhMucItems(), // Gọi hàm đã tạo
                ),


                const SizedBox(height: 10),

                // Dropdown lọc trạng thái
                DropdownButtonFormField<String>(
                  value: _selectTrangThai,
                  hint: const Text('Chọn trạng thái'),
                  onChanged: (value) {
                    setState(() => _selectTrangThai = value);
                    _loadSanPhams();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Hiện', child: Text('Hiện')),
                    DropdownMenuItem(value: 'Ẩn', child: Text('Ẩn')),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ==== DANH SÁCH SẢN PHẨM ====
          Expanded(
            child: _sanPhams.isEmpty
                ? const Center(child: Text('Không có sản phẩm'))
                : ListView.builder(
              itemCount: _sanPhams.length,
              itemBuilder: (context, index) {
                final sp = _sanPhams[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: sp.hinhanh != null && sp.hinhanh!.isNotEmpty
                          ? Image.asset(
                        sp.hinhanh!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
                      )
                          : const Icon(Icons.image, size: 50),
                    ),
                    title: Text(
                      sp.tensp,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Giá: ${_formatCurrency(sp.gia)} - Giảm giá: ${sp.giamgia}%',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            sp.trangthai = (sp.trangthai == 'Hiện') ? 'Ẩn' : 'Hiện';
                            await _db.updateSanPham(sp);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            sp.trangthai == 'Hiện' ? Colors.green : Colors.red,
                            foregroundColor: Colors.white,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(sp.trangthai ?? 'Ẩn'),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editSanPham(sp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSanPham(sp.idsp!),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SanPhamDetailScreen(sanPham: sp),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ==== FLOATING BUTTON ====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSanPham,
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm sản phẩm', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
