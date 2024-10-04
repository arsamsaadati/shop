import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adamarkeet2/selector.dart';
import 'package:adamarkeet2/home_page.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const title_style = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w800,
    fontFamily: 'Irs',
    letterSpacing: 0.5,
    fontSize: 19,
  );

  static const subtitle_style = TextStyle(
    color: Colors.grey,
    fontSize: 24, // اندازه بزرگتر برای متن جدید
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  bool _isNavigating = false;
  double _logoOpacity = 1.0; // برای چشمک زدن لوگو
  late AnimationController _animationController;
  String _displayText = '';
  final String _fullText = "آدامارکـــت";
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _startLogoAnimation(); // شروع انیمیشن لوگو
    _checkUserSession(); // بررسی وضعیت ورود کاربر
    _startTypingAnimation(); // شروع انیمیشن تایپ
  }

  Future<void> _checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Future.delayed(Duration(seconds: 5), () {
      if (!_isNavigating) {
        setState(() {
          _isNavigating = true;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => isLoggedIn ? HomePage() : Selector(),
          ),
        );
      }
    });
  }

  // تابع برای شروع انیمیشن لوگو
  void _startLogoAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // سرعت بیشتر برای چشمک زدن سریع‌تر
      vsync: this,
    )..addListener(() {
      setState(() {
        _logoOpacity = _animationController.value;
      });
    });

    _animationController.repeat(reverse: true);
  }

  // تابع برای شروع انیمیشن تایپ
  void _startTypingAnimation() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9), // پس‌زمینه شفاف‌تر
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10), // فاصله 10 پیکسل از هر طرف
          child: Stack(
            alignment: Alignment.center,
            children: [
              // جلوه‌های برق زدن
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                      stops: [0.5, 1.0],
                      center: Alignment.center,
                      radius: 0.5,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), // کاور شیشه‌ای شفاف
                  borderRadius: BorderRadius.circular(30), // گوشه‌های گرد
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                width: double.infinity, // عرض کاور به صورت کامل
                height: 400, // ارتفاع دلخواه برای کاور
                child: Padding(
                  padding: const EdgeInsets.all(20), // فاصله داخلی
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // مرکز چین کردن محتوا
                    children: [
                      // متن تایپ شونده در بالای صفحه
                      Text(
                        _displayText,
                        style: MyApp.title_style,
                      ),
                      SizedBox(height: 20), // فاصله بین متن و لوگو
                      AnimatedOpacity(
                        opacity: _logoOpacity, // حالت چشمک زن (محو و نمایان)
                        duration: Duration(milliseconds: 500), // افزایش سرعت
                        child: Image.asset(
                          'assets/adalogo.png',
                          height: 150,
                        ),
                      ),
                      SizedBox(height: 10), // فاصله بین لوگو و متن زیر آن
                      Text(
                        "تجربه خرید متفاوت با آدامارکت",
                        style: MyApp.subtitle_style, // استفاده از استایل جدید
                        textAlign: TextAlign.center, // وسط‌چین کردن متن
                      ),
                      Spacer(), // برای جابجایی لودینگ به پایین
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // لودینگ با رنگ طوسی
                      ),
                      SizedBox(height: 10), // فاصله کمتر برای متن پایین
                      Text(
                        "لطفا صبر کنید",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
