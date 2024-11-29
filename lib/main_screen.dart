import 'dart:convert';
import 'package:attedance_app/controllers/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/status_controller.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final StatusController statusController = StatusController();
  final MainScreenController mainScreenController = MainScreenController();

  String attendanceStatus = '출근 전';
  String checkInTime = '';
  String checkOutTime = '';

  List<dynamic> notices = [];

  @override
  void initState() {
    super.initState();
    // 화면 로드 시 출석 정보 자동으로 불러오기
    statusController.getAttendanceInfo().then((_) {
      setState(() {});
    });
    mainScreenController.getNotices().then((_) {
      setState(() {});
    });;
  }

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _showCheckInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('출근 하시겠습니까?'),
          content: Text('출근 버튼을 누르면 출석 체크가 완료됩니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // 출석 체크
                await statusController.checkIn(context);

                // 출석 정보 갱신
                await statusController.getAttendanceInfo();

                // 상태 갱신 후 화면 갱신
                setState(() {});

                // 다이얼로그 닫기
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('퇴근 하시겠습니까?'),
          content: Text('퇴근 버튼을 누르면 퇴근 체크가 완료됩니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // 퇴근 체크
                await statusController.checkOut(context);

                // 출석 정보 갱신
                await statusController.getAttendanceInfo();

                // 상태 갱신 후 화면 갱신
                setState(() {});

                // 다이얼로그 닫기
                Navigator.of(context).pop();
              },
              child: Text('확인'),
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
          Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    '안녕하세요, [사용자 이름]님',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '오늘도 화이팅하세요 !',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: _showCheckInDialog,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 3)),
                            padding: EdgeInsets.all(60),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          child: Text('출근', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: _showCheckOutDialog,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(side: BorderSide(color: Colors.red, width: 3)),
                            padding: EdgeInsets.all(60),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                          ),
                          child: Text('퇴근', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '출근 상태: ${statusController.attendanceStatus}',
                        style: TextStyle(
                          fontSize: 16,
                          color: statusController.attendanceStatus == '퇴근 완료' ? Colors.green : statusController.attendanceStatus == '출근 중' ? Colors.orange : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('출근 시간: ${statusController.checkInTime}', style: TextStyle(fontSize: 16)),
                      if (statusController.checkOutTime != null && statusController.checkOutTime!.isNotEmpty)
                        Text('퇴근 시간: ${statusController.checkOutTime}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 20),
                  // 버튼을 제거하고 출석 상태가 자동으로 업데이트되도록 함
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('출결 요약', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
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
                      Text('최근 공지사항', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      // Add a button to fetch notices

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      mainScreenController.titles.take(5).toList().reversed.length, // 역순으로 가져오기
                          (index) {
                        // 실제 인덱스를 역순으로 접근
                        int actualIndex = mainScreenController.titles.length - 1 - index;

                        // 작성일 포맷
                        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(mainScreenController.createdAts[actualIndex]));

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 배치
                            children: [
                              Expanded(
                                child: Text(
                                  mainScreenController.titles[actualIndex],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1, // 한 줄로 제한
                                  overflow: TextOverflow.ellipsis, // 초과하면 '...'으로 표시
                                ),
                              ),
                              SizedBox(width: 10), // 간격을 위한 SizedBox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
                                children: [

                                  Text(
                                    '${formattedDate}',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        selectedIndex: selectedIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
