import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/danhmuc.dart';
import '../models/product_model.dart';
import '../models/user.dart';

class DBHelper {
  // Lấy đường dẫn DB
  static Future<String> getDBPath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'shopbanhang.db');
  }

  static Future<Database> initDB() async {
    final path = await getDBPath();



    // final dbPath = await getDatabasesPath();
    // await deleteDatabase(join(dbPath, 'shopbanhang.db'));


    return openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        // Tạo bảng users
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

        // Tạo bảng danhmuc
        await db.execute('''
        CREATE TABLE danhmuc (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tendanhmuc TEXT NOT NULL,
          trangthai TEXT,
          hinhanh TEXT
        )
      ''');

        // Tạo bảng sanpham
        await db.execute('''
        CREATE TABLE sanpham (
          idsp INTEGER PRIMARY KEY AUTOINCREMENT,
          tensp TEXT NOT NULL,
          mota TEXT,
          gia REAL NOT NULL,
          hinhanh TEXT,
          xuatxu TEXT,
          khoiluong TEXT,
          thuonghieu TEXT,
          iddanhmuc INTEGER,
          soluong INTEGER DEFAULT 0,
          giamgia REAL DEFAULT 0,
          trangthai TEXT DEFAULT 'Hiện',
          FOREIGN KEY (iddanhmuc) REFERENCES danhmuc(id)
        )
      ''');

        // Tạo bảng giohang
        await db.execute('''
        CREATE TABLE giohang (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  iduser INTEGER,
  idsp INTEGER NOT NULL,
  soluong INTEGER DEFAULT 1,
  FOREIGN KEY (idsp) REFERENCES sanpham(idsp),
  FOREIGN KEY (iduser) REFERENCES users(id)
)

      ''');

        // Tạo bảng donhang (đã có phuongthucthanhtoan)
        await db.execute('''
        CREATE TABLE donhang (
          iddh INTEGER PRIMARY KEY AUTOINCREMENT,
          iduser INTEGER,
          ngaydat TEXT,
          tongtien REAL,
          trangthai TEXT DEFAULT 'Chờ xác nhận',
          diachi TEXT,
          sdt TEXT,
          ghichu TEXT,
          phuongthucthanhtoan TEXT DEFAULT 'COD',
          FOREIGN KEY (iduser) REFERENCES users(id)
        )
      ''');

        // Tạo bảng chitietdonhang
        await db.execute('''
        CREATE TABLE chitietdonhang (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          iddh INTEGER,
          idsp INTEGER,
          soluong INTEGER,
          gia REAL,
          FOREIGN KEY (iddh) REFERENCES donhang(iddh),
          FOREIGN KEY (idsp) REFERENCES sanpham(idsp)
        )
      ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          // Kiểm tra cột phuongthucthanhtoan
          final columns = await db.rawQuery("PRAGMA table_info(donhang)");
          final hasColumn = columns.any((col) => col['name'] == 'phuongthucthanhtoan');

          if (!hasColumn) {
            await db.execute(
                "ALTER TABLE donhang ADD COLUMN phuongthucthanhtoan TEXT DEFAULT 'COD'");
            print("Đã thêm cột phuongthucthanhtoan vào donhang");
          }

          await db.execute('''
          CREATE TABLE IF NOT EXISTS chitietdonhang (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            iddh INTEGER,
            idsp INTEGER,
            soluong INTEGER,
            gia REAL,
            FOREIGN KEY (iddh) REFERENCES donhang(iddh),
            FOREIGN KEY (idsp) REFERENCES sanpham(idsp)
          )
        ''');
          print("Database upgraded: chitietdonhang được tạo nếu chưa có");
        }
      },
    );
  }

  static Future<void> checkColumns() async {
    final db = await initDB();
    final columns = await db.rawQuery("PRAGMA table_info(sanpham)");
    print("Columns in sanpham: $columns");
  }



  // CRUD Danh mục
  Future<int> insertDanhMuc(DanhMuc danhMuc) async {
    final db = await initDB();
    return await db.insert('danhmuc', danhMuc.toMap());
  }

  Future<int> updateDanhMuc(DanhMuc danhMuc) async {
    final db = await initDB();
    return await db.update(
      'danhmuc',
      danhMuc.toMap(),
      where: 'id = ?',
      whereArgs: [danhMuc.id],
    );
  }


  Future<List<Map<String, dynamic>>> getDanhMucs() async {
    final db = await initDB();
    return await db.query('danhmuc');
  }

  Future<void> deleteDanhMuc(int id) async {
    final db = await initDB();
    await db.delete('danhmuc', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Sản phẩm
  Future<int> insertSanPham(SanPham sp) async {
    final db = await initDB();
    return await db.insert('sanpham', sp.toMap());
  }

  Future<List<SanPham>> getAllSanPhams() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('sanpham');
    return List.generate(maps.length, (i) => SanPham.fromMap(maps[i]));
  }

  Future<SanPham?> getSanPhamById(int id) async {
    final db = await initDB();
    final result = await db.query('sanpham', where: 'idsp = ?', whereArgs: [id]);
    return result.isNotEmpty ? SanPham.fromMap(result.first) : null;
  }

  Future<int> updateSanPham(SanPham sp) async {
    final db = await initDB();
    return await db.update(
      'sanpham',
      sp.toMap(),
      where: 'idsp = ?',
      whereArgs: [sp.idsp],
    );
  }

  Future<int> deleteSanPham(int id) async {
    final db = await initDB();
    return await db.delete('sanpham', where: 'idsp = ?', whereArgs: [id]);
  }

  Future<List<SanPham>> searchSanPhams({String? keyword, int? danhMucId}) async {
    final db = await initDB();
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (keyword != null && keyword.isNotEmpty) {
      whereClause += "tensp LIKE ?";
      whereArgs.add('%$keyword%');
    }
    if (danhMucId != null) {
      if (whereClause.isNotEmpty) whereClause += " AND ";
      whereClause += "iddanhmuc = ?";
      whereArgs.add(danhMucId);
    }

    final result = await db.query(
      'sanpham',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs,
    );
    return result.map((e) => SanPham.fromMap(e)).toList();
  }




  // Thêm người dùng mới
  static Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await DBHelper.initDB();
    return await db.insert('users', user); // phải trùng tên bảng
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


// Cập nhật User
  static Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await initDB();
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

// Xóa User
  static Future<int> deleteUser(int id) async {
    final db = await initDB();
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> addToGioHang(int iduser, int idsp) async {
    final db = await initDB();

    final existing = await db.query(
      'giohang',
      where: 'iduser = ? AND idsp = ?',
      whereArgs: [iduser, idsp],
    );

    if (existing.isNotEmpty) {
      final int currentQty = (existing.first['soluong'] as int?) ?? 0;
      await db.update(
        'giohang',
        {'soluong': currentQty + 1},
        where: 'iduser = ? AND idsp = ?',
        whereArgs: [iduser, idsp],
      );
    } else {
      await db.insert('giohang', {
        'iduser': iduser,
        'idsp': idsp,
        'soluong': 1,
      });
    }
  }




  // Future<List<Map<String, dynamic>>> getGioHang(int idUser) async {
  //   final db = await initDB();
  //   return await db.query('giohang', where: 'iduser = ?', whereArgs: [idUser]);
  // }
  Future<List<Map<String, dynamic>>> getGioHang(int iduser) async {
    final db = await initDB();
    return await db.rawQuery('''
    SELECT g.id, g.idsp, g.soluong, s.tensp, s.gia, s.hinhanh
    FROM giohang g
    INNER JOIN sanpham s ON g.idsp = s.idsp
    WHERE g.iduser = ?
  ''', [iduser]);
  }

  Future<void> updateSoLuong(int id, int soluong) async {
    final db = await initDB();
    await db.update('giohang', {'soluong': soluong},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFromGioHang(int id) async {
    final db = await initDB();
    await db.delete('giohang', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearGioHang() async {
    final db = await initDB();
    return await db.delete('giohang');
  }

  Future<double> getTongTien() async {
    final db = await initDB();
    final result = await db.rawQuery('''
    SELECT SUM(g.soluong * s.gia) as total
    FROM giohang g
    JOIN sanpham s ON g.idsp = s.idsp
  ''');
    return result.first['total'] == null ? 0 : (result.first['total'] as double);
  }


// ------------------- CRUD Đơn hàng -------------------
  Future<int> insertDonHang({
    required int iduser,
    required String diachi,
    required String sdt,
    required double tongtien,
    String? ghichu,
    String? phuongthucthanhtoan = 'COD'
  }) async {
    final db = await initDB();
    return await db.insert('donhang', {
      'iduser': iduser,
      'ngaydat': DateTime.now().toIso8601String(),
      'tongtien': tongtien,
      'trangthai': 'Chờ xác nhận',
      'diachi': diachi,
      'sdt': sdt,
      'ghichu': ghichu ?? '',
    'phuongthucthanhtoan': phuongthucthanhtoan,
    });
  }

  Future<List<Map<String, dynamic>>> getAllDonHang() async {
    final db = await initDB();
    return await db.query('donhang', orderBy: 'ngaydat DESC');
  }

  Future<int> updateTrangThaiDonHang(int iddh, String trangthai) async {
    final db = await initDB();
    return await db.update('donhang', {'trangthai': trangthai}, where: 'iddh = ?', whereArgs: [iddh]);
  }

  Future<int> deleteDonHang(int iddh) async {
    final db = await initDB();
    return await db.delete('donhang', where: 'iddh = ?', whereArgs: [iddh]);
  }

// ------------------- CRUD Chi tiết đơn hàng -------------------
  Future<int> insertChiTietDonHang({
    required int iddh,
    required int idsp,
    required int soluong,
    required double gia,
  }) async {
    final db = await initDB();
    return await db.insert('chitietdonhang', {
      'iddh': iddh,
      'idsp': idsp,
      'soluong': soluong,
      'gia': gia,
    });
  }

  Future<List<Map<String, dynamic>>> getChiTietDonHang(int iddh) async {
    final db = await initDB();
    return await db.rawQuery('''
    SELECT c.id, c.soluong, c.gia, s.tensp, s.hinhanh
    FROM chitietdonhang c
    JOIN sanpham s ON c.idsp = s.idsp
    WHERE c.iddh = ?
  ''', [iddh]);
  }


}
