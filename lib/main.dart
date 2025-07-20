
import 'package:flutter/material.dart';
import 'package:shopbanhang/database/db_helper.dart';

import 'package:shopbanhang/screens/giohang_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB(); // Tạo DB nếu chưa có
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GioHangScreen(iduser: 2,),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Tiệm sửa 3CE'),
      home: const GioHangScreen(iduser: 2,),
    );
  }
}
