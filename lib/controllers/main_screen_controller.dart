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

}
