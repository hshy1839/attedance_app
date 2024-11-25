import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 소켓 초기화

  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // 로그인 요청을 보낼 URL
    final url = Uri.parse('http://43.202.64.70:8864/api/users/login');

    // POST 요청을 보내기 위한 데이터
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    // 서버 응답 확인
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // 서버 응답 데이터에서 필요한 값 추출 (null 체크 추가)
      final loginSuccess = responseData['loginSuccess'] ?? false;
      final token = responseData['token'] ?? '';

      if (loginSuccess) {
        // 로그인 성공 시 SharedPreferences에 JWT 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setBool('isLoggedIn', true); // 로그인 상태 플래그 저장

        // 로그인 성공 시 소켓 연결

        // 로그인 성공 다이얼로그 표시
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('로그인', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            content: Text('환영합니다'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 모서리 반경을 0으로 설정
            ),
            actions: [
              TextButton(
                child: Text('확인', style: TextStyle( color: Colors.blueAccent)),
                onPressed: () {
                  // 메인 화면으로 이동하고 이전 모든 화면 제거
                  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
                },
              ),
            ],
          ),
        );
      } else {
        // 로그인 실패
        _showErrorDialog(responseData['message'] ?? 'Error: 500');
      }
    } else {
      // 로그인 실패
      _showErrorDialog('로그인 실패. 아이디와 비밀번호를 확인해 주세요.');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그인 실패', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 모서리 반경을 0으로 설정
        ),
        actions: [
          TextButton(
            child: Text('확인', style: TextStyle( color: Colors.blueAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {

    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // 추가된 부분
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
                  Text(
                    'LOGO',
                    style: TextStyle(color: Color(0xFF6b4eff), fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '복잡했던 출근 ,',
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0),
                  Text(
                    '터치 한번으로 끝',
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 100),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6b4eff),
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text('로그인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text('회원가입', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
