import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 화면 너비를 가득 채움
      height: 56.0, // 헤더 높이 설정
      decoration: BoxDecoration(
        color: Colors.white, // 배경 색상
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'LOGO', // 로고 텍스트
            style: TextStyle(
              color:  Color(0xFF6b4eff), // 텍스트 색상
              fontSize: 20.0, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 굵기
            ),
          ),
        ],
      ),
    );
  }
}
