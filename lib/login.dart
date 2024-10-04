import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // یا صفحه‌ای که باید بعد از ورود نمایش داده شود

class LoginPage extends StatefulWidget {
  final String phoneNumber;

  const LoginPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _login(); // اجرای تابع ورود هنگام بارگذاری صفحه
  }

  Future<void> _login() async {
    // دریافت اطلاعات کاربر از API
    final url = Uri.parse('http://app.adamarkeet.com/get_user_info.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'phone': widget.phoneNumber},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        final userInfo = jsonResponse['data'];

        // ذخیره‌سازی اطلاعات کاربر در shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('phoneNumber', widget.phoneNumber);
        await prefs.setInt('userId', userInfo['id']); // ذخیره id کاربر
        await prefs.setString('userName', userInfo['name']);
        await prefs.setString('userEmail', userInfo['email']);
        // سایر اطلاعات کاربر را نیز می‌توانید ذخیره کنید:
        await prefs.setString('buy', userInfo['buy'] ?? '');
        await prefs.setString('body', userInfo['body'] ?? '');
        await prefs.setInt('percent', userInfo['percent'] ?? 0);
        await prefs.setString('landingPhone', userInfo['landingPhone'] ?? '');
        await prefs.setString('shaba', userInfo['shaba'] ?? '');
        await prefs.setInt('seller', userInfo['seller'] ?? 0);
        await prefs.setInt('suspension', userInfo['suspension'] ?? 0);
        await prefs.setInt('admin', userInfo['admin'] ?? 0);
        await prefs.setString('profile', userInfo['profile'] ?? '');

        // انتقال به صفحه اصلی یا صفحه‌ای که بعد از ورود باید نمایش داده شود
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // یا صفحه‌ای دیگر که مورد نظر است
          ),
        );
      } else {
        // نمایش پیام خطا در صورت عدم موفقیت
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('مشکلی در دریافت اطلاعات کاربر وجود دارد')),
        );
      }
    } else {
      // نمایش پیام خطا در صورت بروز خطا در درخواست
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارتباط با سرور')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // نمایش نشانگر بارگذاری
      ),
    );
  }
}
