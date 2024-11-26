import 'package:flutter/material.dart';
import '../controllers/login/signup_controller.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupController _controller = SignupController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    final color = isError ? Colors.red : Colors.green;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _handleSignup() async {
    final errorMessage = await _controller.submitData(context);
    if (errorMessage == null) {
      _showMessage('회원가입 성공!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _showMessage(errorMessage, isError: true);
      setState(() {}); // 화면 갱신
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: ListView(
            children: [
              _buildTextField(
                  _controller.nameController, '이름', Icons.person),
              _buildTextField(
                  _controller.usernameController, '아이디', Icons.person_outline),
              _buildTextField(
                _controller.phoneNumberController,
                '전화번호',
                Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _controller.passwordController,
                '비밀번호',
                Icons.lock,
                obscureText: true,
              ),
              _buildTextField(
                _controller.confirmPasswordController,
                '비밀번호 확인',
                Icons.lock_outline,
                obscureText: true,
              ),
              _buildTextField(_controller.companyController, '회사', Icons.business),
              _buildTextField(_controller.positionController, '직위', Icons.work),
              _buildTextField(_controller.teamController, '팀', Icons.group),
              if (_controller.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _controller.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignup,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label을 입력해주세요.';
          }
          return null;
        },
      ),
    );
  }
}
