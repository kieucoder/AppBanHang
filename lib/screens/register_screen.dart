import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/login_screen.dart';
import 'package:shopbanhang/database/db_helper.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegisterScreen(),
  ));
}


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  String _selectedGender = 'Nam'; // Default


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      final existingUser = await DBHelper.getUserByEmail(email);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email đã được sử dụng')),
        );
        return;
      }

      final user = {
        'hoten': _nameController.text.trim(),
        'email': email,
        'matkhau': _passwordController.text.trim(),
        'role': 'User',
        'gioitinh': _selectedGender,
        'diachi': _diaChiController.text.trim(),
        'ngaysinh': _ngaySinhController.text.trim(),
      };
      await DBHelper.insertUser(user);




      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/logo.jpg'),
                ),
              ),
              const SizedBox(height: 15),

              const Text(
                "Tạo tài khoản mới",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21409A),
                ),
              ),
              const SizedBox(height: 15),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: _nameController,
                          label: 'Họ và tên',
                          icon: Icons.person,
                          validatorMsg: 'Vui lòng nhập họ tên',
                        ),
                        const SizedBox(height: 15),
                        _buildInputField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          isEmail: true,
                          keyboardType: TextInputType.emailAddress,
                          validatorMsg: 'Vui lòng nhập email hợp lệ',
                        ),
                        const SizedBox(height: 15),
                        // Địa chỉ
                        _buildInputField(
                          controller: _diaChiController,
                          label: 'Địa chỉ',
                          icon: Icons.home,
                          validatorMsg: 'Vui lòng nhập địa chỉ',
                        ),

                        const SizedBox(height: 15),

// Ngày sinh
                        _buildInputField(
                          controller: _ngaySinhController,
                          label: 'Ngày sinh (dd/mm/yyyy)',
                          icon: Icons.cake,
                          keyboardType: TextInputType.datetime,
                          validatorMsg: 'Vui lòng nhập ngày sinh',
                        ),

                        const SizedBox(height: 15),

                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Giới tính",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Nam',
                                          groupValue: _selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          },
                                        ),
                                        const Text('Nam'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Nữ',
                                          groupValue: _selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          },
                                        ),
                                        const Text('Nữ'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),



                        const SizedBox(height: 15),
                        _buildInputField(
                          controller: _passwordController,
                          label: 'Mật khẩu',
                          icon: Icons.lock,
                          isPassword: true,
                          validatorMsg: 'Mật khẩu phải ít nhất 6 ký tự',
                        ),
                        const SizedBox(height: 15),
                        _buildInputField(
                          controller: _confirmPasswordController,
                          label: 'Xác nhận mật khẩu',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isConfirm: true,
                          validatorMsg: 'Mật khẩu không khớp',
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF21409A),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Đã có tài khoản?',
                              style: TextStyle(color: Colors.black87),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (
                                      context) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: const Color(0xFF21409A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    bool isPassword = false,
    bool isEmail = false,
    bool isConfirm = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black, // 🔲 Viền đen khi chưa focus
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black, // 🔲 Viền đen khi focus
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value
              .trim()
              .isEmpty) {
            return validatorMsg;
          }
          if (isEmail && !value.endsWith('@gmail.com')) {
            return 'Email phải có đuôi @gmail.com';
          }
          if (isPassword && value.length < 6) {
            return 'Mật khẩu phải ít nhất 6 ký tự';
          }
          if (isConfirm && value != _passwordController.text) {
            return 'Mật khẩu không khớp';
          }
          return null;
        },
      ),
    );
  }
}