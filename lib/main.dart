//
// import 'package:flutter/material.dart';
// import 'package:shopbanhang/database/db_helper.dart';
//
// import 'package:shopbanhang/screens/giohang_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DBHelper.initDB(); // Tạo DB nếu chưa có
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: CheckoutScreen(iduser: 2,),
//   ));
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: 'Tiệm sửa 3CE'),
//       home: const CheckoutScreen(iduser: 2,),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/admin/list_sp.dart';
import 'package:shopbanhang/screens/admin/list_user.dart';
import 'package:shopbanhang/screens/login_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiệm Sữa 4CE',
      home: const UserListScreen(), // Màn hình checkout
    );
  }
}
