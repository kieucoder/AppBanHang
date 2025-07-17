class Product {
  int? id;
  String tensp;
  String? mota;
  String? motaChiTiet;
  double gia;
  String? hinhanh;
  String? xuatxu;
  String? khoiluong;
  String? thuonghieu;
  int iddmsp;

  Product({
    this.id,
    required this.tensp,
    this.mota,
    this.motaChiTiet,
    required this.gia,
    this.hinhanh,
    this.xuatxu,
    this.khoiluong,
    this.thuonghieu,
    required this.iddmsp,
  });

  Map<String, dynamic> toMap() {
    return {
      'tensp': tensp,
      'mota': mota,
      'mota_chitiet': motaChiTiet,
      'gia': gia,
      'hinhanh': hinhanh,
      'xuatxu': xuatxu,
      'khoiluong': khoiluong,
      'thuonghieu': thuonghieu,
      'iddmsp': iddmsp,
    };
  }
}
