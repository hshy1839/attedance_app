import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/status_controller.dart'; // status_controller.dart 파일을 import 합니다.

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // 현재 선택된 탭의 인덱스를 초기화합니다.
  final StatusController statusController = StatusController(); // StatusController 인스턴스 생성

  // 출근 상태와 출근 시간을 저장하는 변수 추가
  String attendanceStatus = '출근 전';
  String attendanceTime = '';

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index; // 탭이 클릭될 때 선택된 인덱스를 업데이트합니다.
    });
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
                      onPressed: () => statusController.checkAttendance(context), // 출석 버튼 클릭 시 출석 체크
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
                        '출근 상태: $attendanceStatus',
                        style: TextStyle(
                            fontSize: 16,
                            color: attendanceStatus == '출근 중' ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '출근 시간: $attendanceTime',
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
                            Text('팀 회의 공지: 2024년 11월 27일 10:00'),
                            SizedBox(height: 8),
                            Text('연말 정산 관련 안내: 2024년 12월 5일'),
                            SizedBox(height: 8),
                            Text('워크샵 일정 안내: 2024년 12월 10일'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ), // Footer 위젯을 추가
        ],
      ),
      bottomNavigationBar: Footer(
        onTabTapped: _onTabTapped,
        selectedIndex: selectedIndex,
      ),
    );
  }
}

