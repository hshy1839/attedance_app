import 'package:flutter/material.dart';
import 'login_activity/login.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // 초기 화면 설정
      routes: {
        '/login': (context) => LoginScreen(), // 로그인 페이지
        '/main': (context) => MainScreen(),   // 메인 페이지
      },
    );
  }
}
