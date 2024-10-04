import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  final String phoneNumber;

  const RegisterPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  XFile? _profileImage;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://app.adamarkeet.com/sign_user.php'),
      );

      request.fields['name'] = _usernameController.text;
      request.fields['mobile'] = widget.phoneNumber;
      request.fields['email'] = _emailController.text;
      request.fields['password'] = _passwordController.text;

      if (_profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile', _profileImage!.path),
        );
      } else {
        request.fields['profile'] = 'uploads/user/default.png'; // مقدار پیش‌فرض
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(responseData.body);
        _showPopup(jsonResponse['message']);

        if (jsonResponse['status'] == 'success') {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SplashPage()),
            );
          });
        }
      } else {
        _showPopup('خطا در برقراری ارتباط با سرور');
      }
    }
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('شرکت آدامارکت', textAlign: TextAlign.right),
          content: Text(message, textAlign: TextAlign.right),
          actions: [
            TextButton(
              child: const Text('بستن', textAlign: TextAlign.right),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.lightBlue[100],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: _profileImage != null
                        ? Image.file(File(_profileImage!.path), fit: BoxFit.cover)
                        : Image.asset('assets/adalogo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      'ثبت نام در سایت آدامارکـــت',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildTextField(_usernameController, 'نام کاربری'),
                          const SizedBox(height: 20),
                          _buildReadOnlyTextField(widget.phoneNumber, 'شماره موبایل'),
                          const SizedBox(height: 20),
                          _buildTextField(_emailController, 'آدرس ایمیل'),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 20),
                          _buildUploadButton(),
                          const SizedBox(height: 20),
                          _buildRegisterButton(),
                          if (_isLoading)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(30),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'لطفاً $label را وارد کنید';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReadOnlyTextField(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: TextEditingController(text: value),
        textAlign: TextAlign.right,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: 'رمز عبور',
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(30),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'لطفاً رمز عبور را وارد کنید';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.upload),
      label: const Text('آپلود عکس پروفایل', style: TextStyle(color: Colors.blue)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: Colors.blue, width: 1),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      child: const Text('ثبت نام', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: Colors.blue, width: 1),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }
}
