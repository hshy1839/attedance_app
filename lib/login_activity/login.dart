import 'package:flutter/material.dart';
import '../controllers/login/login_controller.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _loginController = LoginController(baseUrl: 'http://192.168.25.26:8864');

  Future<void> _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await _loginController.login(username, password);
      print('Server Response: $response');  // 서버 응답 출력

      if (response['loginSuccess'] == true) {
        await _loginController.saveLoginData(response['token']);
        _showDialog('로그인에 성공했습니다. 환영합니다!', MainScreen());
      } else {
        _showErrorDialog(response['message'] ?? 'Error: 500');
      }
    } catch (e) {
      print('Login error: $e');
      _showErrorDialog('로그인 실패. 아이디와 비밀번호를 확인해 주세요.');
    }

  }


  void _showDialog(String message, Widget nextPage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '로그인',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            child: Text('확인', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => nextPage),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '로그인 실패',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            child: Text('확인', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LOGO', style: TextStyle(color: Color(0xFF6b4eff), fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30),
                  Text('복잡했던 출근 ,', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('터치 한번으로 끝', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 100),
              _buildTextField('아이디', _usernameController),
              SizedBox(height: 20),
              _buildTextField('비밀번호', _passwordController, obscureText: true),
              SizedBox(height: 20),
              _buildButton('로그인', Color(0xFF6b4eff), _handleLogin),
              SizedBox(height: 10),
              _buildButton('회원가입', Colors.grey, () {
                Navigator.pushNamed(context, '/signup');
              }),
            ],
          ),
        ),
      ),
    );
  }
}
