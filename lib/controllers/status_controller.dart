import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // 날짜 형식화
import 'package:shared_preferences/shared_preferences.dart';

class StatusController {
  // 출석 체크 함수
  Future<void> checkAttendance(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final currentDate = DateTime.now().toUtc().add(Duration(hours: 9)); // UTC+9: 한국 시간
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate); // 날짜 포맷 (예: 2024-11-27)

    final formattedTime = DateFormat('HH:mm:ss').format(currentDate); // 시간 포맷 (예: 14:30:00)

    // 출석 상태를 '출근 중'으로 설정
    final attendanceStatus = '출근 중';

    // POST 요청을 보낼 URL
    final url = 'http://192.168.25.26:8864/api/users/createStatus';

    // 헤더 설정
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    // 요청 body
    final body = jsonEncode({
      'attendanceStatus': attendanceStatus,
      'date': formattedDate,
      'checkInTime': formattedTime,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // 출석 상태가 성공적으로 변경되었을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출석 체크가 완료되었습니다.')),
        );
      } else {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출석 체크에 실패했습니다.')),
        );
      }
    } catch (e) {
      // 네트워크 오류 발생 시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와 연결이 실패했습니다. 다시 시도해 주세요.')),
      );
    }
  }
}
