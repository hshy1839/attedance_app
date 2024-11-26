import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final teamController = TextEditingController();

  String? errorMessage;

  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyController.dispose();
    positionController.dispose();
    teamController.dispose();
  }

  Future<String?> submitData(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage = '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
        return errorMessage;
      }

      final requestBody = {
        "name": nameController.text,
        "username": usernameController.text,
        "phoneNumber": phoneNumberController.text,
        "password": passwordController.text,
        "is_active": "true",
        "role": "user",
        "company": companyController.text,
        "position": positionController.text,
        "team": teamController.text,
        "created_at": DateTime.now().toIso8601String(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.25.26:8864/api/user/signup'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          return null; // 성공적으로 완료
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage = responseData['message'] ?? '회원가입 실패';
          return errorMessage;
        }
      } catch (error) {
        errorMessage = '서버 요청 실패: $error';
        return errorMessage;
      }
    }
    return '유효성 검사를 통과하지 못했습니다.';
  }
}
