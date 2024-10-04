import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _buy = '';
  String _body = '';
  int _percent = 0;
  String _landingPhone = '';
  String _shaba = '';
  int _seller = 0;
  int _suspension = 0;
  int _admin = 0;
  String _profile = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber') ?? '';

    if (phoneNumber.isEmpty) {
      _showError('شماره موبایل ذخیره نشده است');
      return;
    }

    final url = Uri.parse('http://app.adamarkeet.com/get_user_info.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'phone': phoneNumber},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        final userInfo = jsonResponse['data'];

        setState(() {
          _name = userInfo['name'] ?? '';
          _email = userInfo['email'] ?? '';
          _phoneNumber = userInfo['number'] ?? '';
          _buy = userInfo['buy'] ?? '';
          _body = userInfo['body'] ?? '';
          _percent = userInfo['percent'] ?? 0;
          _landingPhone = userInfo['landingPhone'] ?? '';
          _shaba = userInfo['shaba'] ?? '';
          _seller = userInfo['seller'] ?? 0;
          _suspension = userInfo['suspension'] ?? 0;
          _admin = userInfo['admin'] ?? 0;
          _profile = userInfo['profile'] != null ? 'https://adamarkeet.com${userInfo['profile']}' : '';
        });
      } else {
        _showError('مشکلی در دریافت اطلاعات کاربر وجود دارد');
      }
    } else {
      _showError('خطا در ارتباط با سرور');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('پروفایل'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 16),
            _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: _profile.isNotEmpty
                  ? _profile
                  : 'https://app.adamarkeet.com/adalogo.png',
              placeholder: (context, url) => Image.asset(
                'assets/default_profile.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Image.network(
                'https://app.adamarkeet.com/adalogo.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _name.isNotEmpty ? _name : 'نام کاربر',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _email.isNotEmpty ? _email : 'ایمیل کاربر',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_phoneNumber.isNotEmpty) _buildDetailRow('شماره موبایل', _phoneNumber),
          if (_buy.isNotEmpty) _buildDetailRow('خرید', _buy),
          if (_body.isNotEmpty) _buildDetailRow('توضیحات', _body),
          if (_percent > 0) _buildDetailRow('درصد', '$_percent%'),
          if (_landingPhone.isNotEmpty) _buildDetailRow('شماره ثابت', _landingPhone),
          if (_shaba.isNotEmpty) _buildDetailRow('شماره شبا', _shaba),
          if (_seller != 0) _buildDetailRow('فروشنده', _seller == 1 ? 'بله' : 'خیر'),
          if (_suspension != 0) _buildDetailRow('تعلیق', _suspension == 1 ? 'بله' : 'خیر'),
          if (_admin != 0) _buildDetailRow('ادمین', _admin == 1 ? 'بله' : 'خیر'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}