import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenController extends ChangeNotifier {
  int selectedIndex = 0; // 현재 선택된 탭 인덱스
  String attendanceStatus = '출근 전'; // 출근 상태
  String attendanceTime = ''; // 출근 시간
  final String targetIp = "192.168.25.56"; // 비교할 대상 IP

  void onTabTapped(int index) {
    selectedIndex = index;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> getNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'http://192.168.25.26:8864/api/users/noticeList';
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      notifyListeners();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final today = DateTime.now().toIso8601String().split('T')[0]; // 오늘 날짜 (YYYY-MM-DD)

        final attendance = data.firstWhere(
              (attendance) => attendance['date'] == today,
          orElse: () => {},
        );

      }
    } catch (e) {
      print('Error: $e');
    } finally {

      notifyListeners();
    }
  }
}
