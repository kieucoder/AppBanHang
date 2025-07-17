class DanhMuc {
  final int? id;
  final String tenDanhMuc;
  final String? trangThai;

  DanhMuc({
    this.id,
    required this.tenDanhMuc,
    this.trangThai,
  });

  factory DanhMuc.fromMap(Map<String, dynamic> map) {
    return DanhMuc(
      id: map['iddanhmuc'],
      tenDanhMuc: map['tendanhmuc'],
      trangThai: map['trangthai'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iddanhmuc': id,
      'tendanhmuc': tenDanhMuc,
      'trangthai': trangThai,
    };
  }
}
