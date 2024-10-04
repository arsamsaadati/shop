import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'check.dart';

class SendVerificationCode extends StatefulWidget {
  final String phoneNumber;

  const SendVerificationCode({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _SendVerificationCodeState createState() => _SendVerificationCodeState();
}

class _SendVerificationCodeState extends State<SendVerificationCode> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = false;
  int _remainingTime = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 120;
    _isButtonDisabled = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtpCode(String phoneNumber, List<String> otpCode) async {
    final apiUrl = 'http://app.adamarkeet.com/verify_otp.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'phoneNumber': phoneNumber,
        'otpCode': otpCode.join(''),
      },
    );

    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CheckPage(phoneNumber: phoneNumber),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در پردازش پاسخ')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در درخواست')),
      );
    }
  }

  Future<void> _resendCode() async {
    // پاک کردن محتویات فیلدها
    for (var controller in _otpControllers) {
      controller.clear();
    }

    // تمرکز بر روی ورودی اول
    FocusScope.of(context).requestFocus(FocusNode());

    final apiUrl = 'http://app.adamarkeet.com/send_sms.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'phoneNumber': widget.phoneNumber,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('کد جدید ارسال شد')),
      );
      _startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارسال کد جدید')),
      );
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isEmpty) {
      // در صورت خالی شدن، به ورودی قبلی برگردد
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    } else if (value.length == 1) {
      // در صورت پر شدن، به ورودی بعدی برود
      if (index < _otpControllers.length - 1) {
        FocusScope.of(context).nextFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // رنگ پس‌زمینه سفید
      body: Center( // مرکز چینش
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // عرض کاور
          height: MediaQuery.of(context).size.height * 0.5, // ارتفاع کاور
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // کاور شیشه‌ای مات
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // مرکز چینش عمودی
            crossAxisAlignment: CrossAxisAlignment.center, // مرکز چینش افقی
            children: <Widget>[
              Text(
                "کد تایید را وارد کنید",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onOtpChanged(value, index),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفاً یک عدد وارد کنید';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final otpCode = _otpControllers.map((controller) => controller.text).toList();
                      _verifyOtpCode(widget.phoneNumber, otpCode);
                    }
                  },
                  child: Text(
                    "تأیید",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: TextButton.styleFrom(
                    fixedSize: Size(330, 60),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _remainingTime > 0
                  ? Text(
                "دوباره ارسال کد بعد از ${_remainingTime ~/ 60}:${_remainingTime % 60} دقیقه",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
                  : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: _isButtonDisabled ? null : _resendCode,
                  child: Text(
                    "ارسال کد جدید",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  style: TextButton.styleFrom(
                    fixedSize: Size(330, 60),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}