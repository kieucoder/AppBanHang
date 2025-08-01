
import 'dart:math';
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


    return openDatabase(
      path,
      version: 7,
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

        // Tạo bảng sanpham (có sẵn cột trangthai)
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

        // Tạo bảng donhang (có cột tennguoidat và phuongthucthanhtoan)
        await db.execute('''
        CREATE TABLE donhang (
          iddh INTEGER PRIMARY KEY AUTOINCREMENT,
          iduser INTEGER,
          tennguoidat TEXT,
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


        await db.execute('''
       CREATE TABLE chatbox (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        sender TEXT,
        message TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 7) {
          await db.execute('''
      CREATE TABLE IF NOT EXISTS chatbox (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        sender TEXT,
        message TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
          print("Đã thêm bảng chatbox");
        }

        // Nếu bảng chatbox tồn tại nhưng thiếu cột thì thêm
        final columns = await db.rawQuery("PRAGMA table_info(chatbox)");
        final columnNames = columns.map((c) => c['name']).toList();
        if (!columnNames.contains('user_id')) {
          await db.execute('ALTER TABLE chatbox ADD COLUMN user_id INTEGER;');
        }
        if (!columnNames.contains('created_at')) {
          await db.execute('ALTER TABLE chatbox ADD COLUMN created_at TEXT;');
        }
      },




    );
  }

  Future<int> insertChatMessage({
    required int userId,
    required String sender,
    required String message,
  }) async {
    final db = await initDB();

    try {
      return await db.insert('chatbox', {
        'user_id': userId, // Đúng tên cột trong DB
        'sender': sender,
        'message': message,
        'created_at': DateTime.now().toIso8601String(), // Đúng tên cột
      });
    } catch (e) {
      print("Lỗi insert chat message: $e");
      return -1; // trả về -1 nếu lỗi
    }
  }


  // Lấy lịch sử chat của 1 user
  Future<List<Map<String, dynamic>>> getChatMessages(int userId) async {
    final db = await initDB();
    return await db.query(
      'chatbox',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at ASC',

    );
  }


  // lấy danh sách tất cả user chat vs admin desc sắp xếp theo moi
  Future<List<Map<String, dynamic>>> getAllChatUsers() async {
    final db = await initDB();
    return await db.rawQuery('''
    SELECT user_id, MAX(created_at) as last_message_time
    FROM chatbox
    GROUP BY user_id
    ORDER BY last_message_time DESC
    
  ''');
  }




// Xóa toàn bộ chat của 1 user
  Future<int> clearChatMessages(int userId) async {
    final db = await initDB();
    return await db.delete('chatbox', where: 'user_id = ?', whereArgs: [userId]);
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

    // 1. Lấy trạng thái hiện tại của danh mục trong DB
    final oldData = await db.query(
      'danhmuc',
      where: 'id = ?',
      whereArgs: [danhMuc.id],
      limit: 1,
    );

    String? oldTrangThai = oldData.isNotEmpty ? oldData.first['trangthai'] as String? : null;

    // 2. Cập nhật danh mục
    final result = await db.update(
      'danhmuc',
      danhMuc.toMap(),
      where: 'id = ?',
      whereArgs: [danhMuc.id],
    );

    // 3. Nếu trạng thái danh mục thay đổi, cập nhật sản phẩm trong danh mục
    if (oldTrangThai != danhMuc.trangthai) {
      // Chuyển trạng thái danh mục -> trạng thái sản phẩm
      String trangThaiSanPham = (danhMuc.trangthai == 'Hiển thị') ? 'Hiện' : 'Ẩn';

      await db.update(
        'sanpham',
        {'trangthai': trangThaiSanPham},
        where: 'iddanhmuc = ?',
        whereArgs: [danhMuc.id],
      );
    }

    return result;
  }



  Future<List<Map<String, dynamic>>> getDanhMucs({bool onlyVisible = false}) async {
    final db = await initDB();
    return await db.query(
      'danhmuc',
      where: onlyVisible ? 'trangthai = ?' : null,
      whereArgs: onlyVisible ? ['Hiển thị'] : null,
    );
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
    final maps = await db.query(
      'sanpham',
      where: 'trangthai = ?',
      whereArgs: ['Hiện'],
    );
    return List.generate(maps.length, (i) => SanPham.fromMap(maps[i]));
  }



  Future<SanPham?> getSanPhamById(int id) async {
    final db = await initDB();
    final result = await db.query(
        'sanpham', where: 'idsp = ?', whereArgs: [id]);
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

  Future<List<SanPham>> searchSanPhams(
      {String? keyword, int? danhMucId, String? trangThai}) async {
    final db = await initDB();
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (keyword != null && keyword.isNotEmpty) {
      whereClause += "(tensp LIKE ? OR thuonghieu LIKE ? OR xuatxu LIKE ?)";
      whereArgs.addAll(['%$keyword%', '%$keyword%', '%$keyword%']);
    }
    if (danhMucId != null) {
      if (whereClause.isNotEmpty) whereClause += " AND ";
      whereClause += "iddanhmuc = ?";
      whereArgs.add(danhMucId);
    }

    if(trangThai!= null){
      if(whereClause.isNotEmpty) whereClause += " AND ";
      whereClause += "trangthai = ?";
      whereArgs.add(trangThai);
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

  Future<Map<String, dynamic>?> getUserByName(String name) async {
    final db = await initDB();
    final result = await db.query(
      'users',
      where: 'hoten = ?',
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }




  //gán danh sách thông tin người dùng
  Future<Map<String, dynamic>?> getUserById(int iduser) async {
    final db = await initDB();
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [iduser],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }


  // Trả về toàn bộ danh sách người dùng
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await initDB();
    return await db.query('users');
  }



  Future<String> resetPasswordLocal(String email) async {
    final db = await initDB();
    final user = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (user.isEmpty) {
      return 'Email không tồn tại trong hệ thống.';
    }

    // Sinh mật khẩu mới ngẫu nhiên (6 số)
    String newPassword = (100000 + Random().nextInt(900000)).toString();

    // Cập nhật mật khẩu mới vào DB
    await db.update(
      'users',
      {'matkhau': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return 'Mật khẩu mới của bạn là: $newPassword';
  }





  Future<int> updateUserPassword(int userId, String newPassword) async {
    final db = await initDB();
    return await db.update(
      'users',
      {'matkhau': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }



  //hàm đăng nhập
  static Future<Map<String, dynamic>?> loginUser(String email,
      String password) async {
    final db = await initDB();
    final result = await db.query(
      'users',
      where: 'email = ? AND matkhau = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }





  static Future<int> updateUser({
    required int id,
    required Map<String, dynamic> userData,
  }) async {
    final db = await initDB();
    print("Cập nhật user ID: $id với data: $userData");
    return await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [id],
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

  Future<int> clearGioHang(int id) async {
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
    return result.first['total'] == null ? 0 : (result
        .first['total'] as double);
  }


  //CRUD ĐƠN HÀNG

  Future<int> insertDonHang({
    required int iduser,
    required String diachi,
    required String sdt,
    required double tongtien,
    String? ghichu,
    String phuongthucthanhtoan = 'COD',
    required List<Map<String, dynamic>> gioHang,
  }) async {
    final db = await initDB();
    final user = await getUserById(iduser);

    int iddh = await db.insert('donhang', {
      'iduser': iduser,
      'tennguoidat': user?['hoten'] ?? 'Khách hàng',
      'ngaydat': DateTime.now().toIso8601String(),
      'tongtien': tongtien,
      'trangthai': 'Chờ xác nhận',
      'diachi': diachi,
      'sdt': sdt,
      'ghichu': ghichu ?? '',
      'phuongthucthanhtoan': phuongthucthanhtoan,
    });

    for (var item in gioHang) {
      await db.insert('chitietdonhang', {
        'iddh': iddh,
        'idsp': item['idsp'],
        'soluong': item['soluong'],
        'gia': item['gia'],
      });
    }

    return iddh;
  }

  Future<List<Map<String, dynamic>>> getDonHangsFiltered(String status, String keyword) async {
    final db = await initDB();
    String query = '''
    SELECT * FROM donhang
    WHERE (tennguoidat LIKE ? OR CAST(iddh AS TEXT) LIKE ?)
  ''';
    List<dynamic> args = ['%$keyword%', '%$keyword%'];

    if (status != 'Tất cả') {
      query += ' AND trangthai = ?';
      args.add(status);
    }
    query += 'ORDER BY iddh DESC';
    return await db.rawQuery(query, args);
  }

  Future<int> updateTrangThaiDonHang(int iddh, String trangThai) async {
    final db = await initDB();
    return await db.update(
      'donhang',
      {'trangthai': trangThai},
      where: 'iddh = ?',
      whereArgs: [iddh],
    );
  }




  Future<List<Map<String, dynamic>>> getAllDonHang() async {
    final db = await initDB();
    return await db.query('donhang', orderBy: 'ngaydat DESC');
  }


  Future<Map<String, dynamic>?> getDonHangById(int iddh) async {
    final db = await initDB();
    final result = await db.query(
      'donhang',
      where: 'iddh = ?',
      whereArgs: [iddh],
    );
    return result.isNotEmpty ? result.first : null;
  }




  Future<List<Map<String, dynamic>>> getLichSuDatTour(int idUser) async {
    final db = await initDB();

    // Lấy tất cả đơn hàng của người dùng kèm tổng tiền và trạng thái
    final List<Map<String, dynamic>> orders = await db.query(
      'donhang',
      where: 'iduser = ?',
      whereArgs: [idUser],
      orderBy: 'ngaydat DESC',
    );

    // Với mỗi đơn hàng, lấy chi tiết sản phẩm từ chitietdonhang + sanpham
    List<Map<String, dynamic>> lichSu = [];

    for (var order in orders) {
      final chitiet = await db.rawQuery('''
      SELECT ct.idsp, ct.soluong, ct.gia, sp.tensp, sp.hinhanh
      FROM chitietdonhang ct
      JOIN sanpham sp ON ct.idsp = sp.idsp
      WHERE ct.iddh = ?
    ''', [order['iddh']]);

      lichSu.add({
        'iddh': order['iddh'],
        'ngaydat': order['ngaydat'],
        'tongtien': order['tongtien'],
        'trangthai': order['trangthai'],
        'diachi': order['diachi'],
        'sdt': order['sdt'],
        'ghichu': order['ghichu'],
        'phuongthucthanhtoan': order['phuongthucthanhtoan'],
        'chitiet': chitiet, // Danh sách sản phẩm trong đơn hàng
      });
    }

    return lichSu;
  }



// CRUD Chi tiết đơn hàng
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





