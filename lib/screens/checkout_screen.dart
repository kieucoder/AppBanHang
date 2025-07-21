import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopbanhang/database/db_helper.dart';
import 'package:shopbanhang/screens/success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final int iduser;
  final double tongTien;

  const CheckoutScreen({
    super.key,
    required this.iduser,
    required this.tongTien,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _diaChiController = TextEditingController();
  final TextEditingController _ghiChuController = TextEditingController();

  String _phuongThucThanhToan = 'COD';
  List<Map<String, dynamic>> _gioHang = [];
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadGioHang();

  }

  Future<void> _loadGioHang() async {
    final data = await DBHelper().getGioHang(widget.iduser);
    setState(() {
      _gioHang = data;
    });
  }

  /// Lấy thông tin user từ database
  // Future<void> _loadUserInfo() async {
  //   final user = await DBHelper().getUserById(widget.iduser);
  //   if (user != null) {
  //     setState(() {
  //       _userInfo = user;
  //       _tenController.text = user['hoten'] ?? '';
  //       _sdtController.text = user['sdt'] ?? '';
  //       _diaChiController.text = user['diachi'] ?? '';
  //     });
  //   }
  // }



  @override
  void dispose() {
    _tenController.dispose();
    _sdtController.dispose();
    _diaChiController.dispose();
    _ghiChuController.dispose();
    super.dispose();
  }

  String _formatCurrency(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  /// Lưu đơn hàng và chuyển sang màn hình Success
  Future<void> _tienHanhThanhToan() async {
    if (_formKey.currentState!.validate()) {
      if (_gioHang.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giỏ hàng của bạn trống.')),
        );
        return;
      }

      final db = DBHelper();
      int iddh = await db.insertDonHang(
        iduser: widget.iduser,
        diachi: _diaChiController.text,
        sdt: _sdtController.text,
        tongtien: widget.tongTien,
        ghichu: _ghiChuController.text,
        phuongthucthanhtoan: _phuongThucThanhToan,
        gioHang: _gioHang,
      );

      await db.clearGioHang(widget.iduser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ThanhToanScreen(
            iduser: widget.iduser,
            tenKhachHang: _tenController.text,
            sdt: _sdtController.text,
            diaChi: _diaChiController.text,
            ghiChu: _ghiChuController.text,
            tongTien: widget.tongTien,
            phuongThuc: _phuongThucThanhToan,
            iddh: iddh,
          ),
        ),
      );
    }
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text,
        String? Function(String?)? validator,
        int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán đơn hàng'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildLeftForm()),
            const SizedBox(width: 20),
            Expanded(flex: 3, child: _buildRightCart()),
          ],
        )
            : ListView(
          children: [
            _buildRightCart(),
            const SizedBox(height: 16),
            _buildLeftForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin người nhận',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInput(
                'Họ tên',
                _tenController,
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 12),
              _buildInput(
                'Số điện thoại',
                _sdtController,
                type: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildInput(
                'Địa chỉ nhận hàng',
                _diaChiController,
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 12),
              _buildInput(
                'Ghi chú (không bắt buộc)',
                _ghiChuController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                'Phương thức thanh toán',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: const Text('Thanh toán khi nhận hàng (COD)'),
                value: 'COD',
                groupValue: _phuongThucThanhToan,
                onChanged: (value) =>
                    setState(() => _phuongThucThanhToan = value!),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _tienHanhThanhToan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Tiến hành thanh toán',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightCart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giỏ hàng của bạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: _gioHang.isEmpty
                  ? const Center(child: Text('Giỏ hàng trống'))
                  : ListView.builder(
                itemCount: _gioHang.length,
                itemBuilder: (context, index) {
                  final item = _gioHang[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item['hinhanh'] ?? 'assets/default_image.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['tensp'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${_formatCurrency(item['gia'])} x ${item['soluong']}',
                      style: const TextStyle(
                          color: Colors.red, fontSize: 13),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatCurrency(widget.tongTien),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
