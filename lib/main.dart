import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/add_danhmuc.dart';

import 'package:shopbanhang/screens/list_danhmuc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiệm Sữa 4CE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const DanhSachDanhMucScreen(), // ✅ Trang thêm danh mục
    );
  }
}
