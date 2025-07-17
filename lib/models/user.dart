class User {
  final int id;
  final String hoten;
  final String email;
  final String matkhau;
  final String role;
  final String gioitinh;
  final String diachi;
  final String ngaysinh;

  User({
    required this.id,
    required this.hoten,
    required this.email,
    required this.matkhau,
    required this.role,
    required this.gioitinh,
    required this.diachi,
    required this.ngaysinh,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      hoten: map['hoten'],
      email: map['email'],
      matkhau: map['matkhau'],
      role: map['role'],
      gioitinh: map['gioitinh'],
      diachi: map['diachi'],
      ngaysinh: map['ngaysinh'],
    );
  }
}
