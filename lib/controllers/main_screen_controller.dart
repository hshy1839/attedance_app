import 'package:flutter/material.dart';
import 'dart:io';

class MainScreenController extends ChangeNotifier {
  int selectedIndex = 0; // 현재 선택된 탭 인덱스
  String attendanceStatus = '출근 전'; // 출근 상태
  String attendanceTime = ''; // 출근 시간
  final String targetIp = "192.168.25.56"; // 비교할 대상 IP

  void onTabTapped(int index) {
    selectedIndex = index;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> checkAttendance(BuildContext context) async {
    try {
      String? localIp = await _getLocalIpAddress();
      if (localIp?.trim() == targetIp.trim()) {
        attendanceStatus = '출근 중';
        attendanceTime = TimeOfDay.now().format(context);
        notifyListeners(); // UI 업데이트
        _showAlert(context, "출석 완료", "정상적으로 출석되었습니다!");
      } else {
        _showAlert(context, "출석 실패", "올바른 네트워크에 연결되어 있지 않습니다.");
      }
    } catch (e) {
      _showAlert(context, "오류 발생", "네트워크 확인 중 오류가 발생했습니다.");
    }
  }

  Future<String?> _getLocalIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        if (interface.name.contains('wlan')) {
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
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
