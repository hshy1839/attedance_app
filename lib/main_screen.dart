import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

import 'header.dart'; // Header 위젯을 import 합니다.
import 'footer.dart'; // Footer 위젯을 import 합니다.

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // 현재 선택된 탭의 인덱스를 초기화합니다.
  final String targetIp = "192.168.25.26"; // 비교할 대상 IP

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index; // 탭이 클릭될 때 선택된 인덱스를 업데이트합니다.
    });
  }

  Future<void> _checkAttendance() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      print('현재 네트워크 상태: $connectivityResult'); // 추가된 로그

      if (connectivityResult == ConnectivityResult.wifi) {
        String? localIp = await _getLocalIpAddress();
        print('로컬 IP: $localIp, 대상 IP: $targetIp');
        if (localIp == targetIp) {

          _showAlert(context, "출석 완료", "정상적으로 출석되었습니다!");
        } else {
          _showAlert(context, "출석 실패", "올바른 네트워크에 연결되어 있지 않습니다.");
        }
      } else {
        _showAlert(context, "출석 실패", "Wi-Fi에 연결되어 있지 않습니다.");
      }
    } catch (e) {
      print('네트워크 오류: $e'); // 오류 디버깅 로그
      _showAlert(context, "오류 발생", "네트워크 확인 중 오류가 발생했습니다.");
    }
  }


  Future<String?> _getLocalIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            return addr.address; // IPv4 주소 반환

          }
        }
      }
    } catch (e) {
      print("IP 주소를 가져오는 중 오류 발생: $e");
    }
    return null; // IP 주소를 가져오지 못한 경우 null 반환
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          Header(), // Header 위젯을 추가
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // 전체적인 여백 설정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20), // Header와 나머지 컨텐츠 간격
                  Text(
                    '안녕하세요, [사용자 이름]님',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '오늘도 화이팅하세요 !',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),

                  // 중앙: 출근 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: _checkAttendance, // 출석 버튼 클릭 시 동작
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.blue, width: 3),
                        ),
                        padding: EdgeInsets.all(60), // 버튼 크기를 조금 더 줄임
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                      ),
                      child: Text(
                        '출근',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // 간격을 줄임

                  // 출근 상태 및 시간
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '출근 상태: 출근 중',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '출근 시간: 09:00',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 30), // 간격 조정

                  // 하단: 출결 상태 및 공지사항 카드
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '출결 요약',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity, // 화면 전체 너비에 맞춤
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색 흰색
                          borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // 그림자 색상 및 투명도
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // 그림자의 위치 조정
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16), // 내부 여백
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- 팀 회의 공지: 2024년 11월 27일 10:00'),
                            SizedBox(height: 8),
                            Text('- 연말 정산 관련 안내: 2024년 12월 5일'),
                            SizedBox(height: 8),
                            Text('- 워크샵 일정 안내: 2024년 12월 10일'),
                            SizedBox(height: 8),
                            Text('- 신입 직원 환영회: 2024년 12월 15일'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // 공지사항 카드
                      Text(
                        '최근 공지사항',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity, // 화면 전체 너비에 맞춤
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색 흰색
                          borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // 그림자 색상 및 투명도
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // 그림자의 위치 조정
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16), // 내부 여백
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- 팀 회의 공지: 2024년 11월 27일 10:00'),
                            SizedBox(height: 8),
                            Text('- 연말 정산 관련 안내: 2024년 12월 5일'),
                            SizedBox(height: 8),
                            Text('- 워크샵 일정 안내: 2024년 12월 10일'),
                            SizedBox(height: 8),
                            Text('- 신입 직원 환영회: 2024년 12월 15일'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        onTabTapped: _onTabTapped,
        selectedIndex: selectedIndex,
      ),
    );
  }
}
