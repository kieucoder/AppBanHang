class SanPham {
  int? idsp;
  String tensp;
  String? mota;
  double gia;
  String? hinhanh;
  String? xuatxu;
  String? khoiluong;
  String? thuonghieu;
  int? iddanhmuc;
  double giamgia;
  int soluong;
  String? trangthai;

  SanPham({
    this.idsp,
    required this.tensp,
    this.mota,
    required this.gia,
    this.hinhanh,
    this.xuatxu,
    this.khoiluong,
    this.thuonghieu,
    this.iddanhmuc,
    this.giamgia = 0,
    this.soluong = 0,
    this.trangthai = 'Hiện',
  });

  Map<String, dynamic> toMap() {
    return {
      'idsp': idsp,
      'tensp': tensp,
      'mota': mota,
      'gia': gia,
      'hinhanh': hinhanh,
      'xuatxu': xuatxu,
      'khoiluong': khoiluong,
      'thuonghieu': thuonghieu,
      'iddanhmuc': iddanhmuc,
      'giamgia': giamgia,
      'soluong': soluong,
      'trangthai': trangthai,
    };
  }

  factory SanPham.fromMap(Map<String, dynamic> map) {
    return SanPham(
      idsp: map['idsp'],
      tensp: map['tensp'],
      mota: map['mota'],
      gia: map['gia'],
      hinhanh: map['hinhanh'],
      xuatxu: map['xuatxu'],
      khoiluong: map['khoiluong'],
      thuonghieu: map['thuonghieu'],
      iddanhmuc: map['iddanhmuc'],
      giamgia: map['giamgia'],
      soluong: map['soluong'],
      trangthai: map['trangthai'],
    );
  }
}
