import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/danhmuc.dart';
import '../models/user.dart';



class DBHelper {


  // lấy đường dẫn trong db
  static Future<String> getDBPath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'shop.db');
  }

  static Future<void> deleteDB() async {
    final path = await getDBPath();
    await deleteDatabase(path);
  }
  // khởi tạo db và tạo bảng nếu chưa có
  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'shopbanhang.db');

    return openDatabase(
      path,
      version: 1, // Tăng nếu cần cập nhật bảng
      onCreate: (db, version) async {
      // Bảng người dùng
      await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hoten TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      matkhau TEXT NOT NULL,
      role TEXT NOT NULL,
      gioitinh TEXT NOT NULL,
      diachi TEXT NOT NULL,
      ngaysinh TEXT NOT NULL
    )
  ''');

      // Bảng danh mục chính
      await db.execute('''
    CREATE TABLE danhmuc (
      iddanhmuc INTEGER PRIMARY KEY AUTOINCREMENT,
      tendanhmuc TEXT NOT NULL,
      trangthai TEXT DEFAULT NULL
    )
  ''');



      // Bảng sản phẩm
      await db.execute('''
  CREATE TABLE sanpham (
    idsp INTEGER PRIMARY KEY AUTOINCREMENT,
    tensp TEXT NOT NULL,
    mota TEXT,
    mota_chitiet TEXT,
    gia REAL NOT NULL,
    hinhanh TEXT,
    xuatxu TEXT,
    khoiluong TEXT,
    thuonghieu TEXT,
    iddanhmuc INTEGER,
    trangthai TEXT DEFAULT 'Hiện',
    FOREIGN KEY (iddanhmuc) REFERENCES danhmuc(iddanhmuc)
  )
''');

      },
    );
  }




  static Future<int> insertDanhMucSP(Map<String, dynamic> dmsp) async {
    final db = await initDB();
    return await db.insert('danhmuc', dmsp);
  }

  // static Future<List<Map<String, dynamic>>> getAllDanhMucSP() async {
  //   final db = await initDB();
  //   return await db.query('danhmuc');
  // }

  // static Future<List<DanhMuc>> getDanhMucList() async {
  //   final db = await initDB();
  //   final List<Map<String, dynamic>> maps = await db.query('danhmuc');
  //   return maps.map((e) => DanhMuc.fromMap(e)).toList();
  // }
  static Future<List<DanhMuc>> getDanhMucList() async {
    final db = await initDB();
    final maps = await db.query('danhmuc');
    return maps.map((e) => DanhMuc.fromMap(e)).toList();
  }

  static Future<int> insertSanPham(Map<String, dynamic> sp) async {
    final db = await initDB();
    return await db.insert('sanpham', sp);
  }

  // Thêm người dùng mới
  static Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await initDB();
    return await db.insert('users', user);
  }

  // Kiểm tra email đã tồn tại chưa
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await initDB();
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }


  // Trả về toàn bộ danh sách người dùng
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await initDB();
    return await db.query('users');
  }


  //Xây dựng hàm kiểm tra đăng nhập
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await initDB();
    final result = await db.query(
      'users',
      where: 'email = ? AND matkhau = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }






}
