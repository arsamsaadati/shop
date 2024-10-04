import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'register.dart';

class CheckPage extends StatelessWidget {
  final String phoneNumber;

  const CheckPage({Key? key, required this.phoneNumber}) : super(key: key);

  Future<void> _checkUser(BuildContext context) async {
    final url = Uri.parse('http://app.adamarkeet.com/check_phone.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'phone': phoneNumber},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      bool exists = jsonResponse['exists'] == true || jsonResponse['exists'] == 'true';

      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(phoneNumber: phoneNumber),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(phoneNumber: phoneNumber),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارتباط با سرور')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkUser(context);

    return Scaffold(
      appBar: AppBar(title: Text('در حال بررسی')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
