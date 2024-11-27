import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class StatusController {
  final String targetIp = "192.168.25.56"; // 비교할 대상 IP

  // 출근 상태와 출근 시간을 저장하는 변수
  String attendanceStatus = '출근 전';
  String attendanceTime = '';

  // 출석 상태를 서버에 전송하는 함수
  Future<void> postAttendanceStatus(String username, String status, String attendanceTime, String token) async {
    final url = Uri.parse('http://192.168.25.56:8864/api/user/$username/status');
    try {
      final Map<String, String> data = {
        'status': status,
        'attendanceTime': attendanceTime,
        'date': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('출석 상태가 서버에 성공적으로 전송되었습니다.');
      } else {
        print('서버와의 통신 오류 발생: ${response.statusCode}');
      }
    } catch (e) {
      print('출석 상태를 서버에 보내는 중 오류 발생: $e');
    }
  }

// 출석 체크 로직
  Future<void> checkAttendance(BuildContext context) async {
    try {
      String? localIp = await _getLocalIpAddress();
      print("로컬 IP: ${localIp?.trim()}, 대상 IP: ${targetIp.trim()}");

      if (localIp?.trim() == targetIp.trim()) {
        attendanceStatus = '출근 중';
        attendanceTime = TimeOfDay.now().format(context);

        // SharedPreferences에서 저장된 token과 username 가져오기
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String? username = prefs.getString('username'); // 여기에 'username' 키를 사용

        if (token == null) {
          print("토큰이 없습니다.");
        }
        if (username == null) {
          print("사용자 이름이 없습니다.");
        }

        if (token != null && username != null) {
          await postAttendanceStatus(username, attendanceStatus, attendanceTime, token);
          _showAlert(context, "출석 완료", "정상적으로 출석되었습니다!");
        } else {
          _showAlert(context, "출석 실패", "토큰 또는 사용자 이름을 찾을 수 없습니다.");
        }
      } else {
        _showAlert(context, "출석 실패", "올바른 네트워크에 연결되어 있지 않습니다.");
      }
    } catch (e) {
      print('네트워크 오류: $e');
      _showAlert(context, "오류 발생", "네트워크 확인 중 오류가 발생했습니다.");
    }
  }

  // 로컬 IP 주소를 가져오는 함수
  Future<String?> _getLocalIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        if (interface.name.contains('wlan')) { // Wi-Fi 인터페이스만 선택
          for (var addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4) {
              return addr.address;
            }
          }
        }
      }
    } catch (e) {
      print("IP 주소를 가져오는 중 오류 발생: $e");
    }
    return null;
  }


  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 알림 창 닫기
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
