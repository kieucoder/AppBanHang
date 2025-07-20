class DanhMuc {
  int? id;
  String tendanhmuc;
  String? trangthai;
  String? hinhanh;

  DanhMuc({
    this.id,
    required this.tendanhmuc,
    this.trangthai,
    this.hinhanh,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tendanhmuc': tendanhmuc,
      'trangthai': trangthai,
      'hinhanh': hinhanh,
    };
  }

  factory DanhMuc.fromMap(Map<String, dynamic> map) {
    return DanhMuc(
      id: map['id'],
      tendanhmuc: map['tendanhmuc'],
      trangthai: map['trangthai'],
      hinhanh: map['hinhanh'],
    );
  }
}
