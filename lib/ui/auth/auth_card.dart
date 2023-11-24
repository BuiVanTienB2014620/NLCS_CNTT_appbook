import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../shared/dialog_utils.dart';
import 'auth_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        // Đăng nhập
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Đăng ký
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } catch (error) {
      if (mounted) {
        showErrorDialog(
          context,
          (error is HttpException) ? error.toString() : 'Xác thực thất bại',
        );
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailField(),
                _buildPasswordField(),
                if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
                const SizedBox(
                  height: 9.0,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    if (isSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return _buildSubmitButton();
                  },
                ),
                _buildAuthModeSwitchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          color: _authMode == AuthMode.login
              ? Colors.green // Màu cho LOGIN
              : Colors.red, // Màu cho SIGNUP
        ),
      ),
      child: Text(
          '${_authMode == AuthMode.login ? 'ĐĂNG KÝ' : 'ĐĂNG NHẬP'} .Chưa tài khoản?'),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.green, // Màu nền cho nút
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        textStyle: TextStyle(
          color: Colors.white, // Màu cho chữ trên nút
        ),
      ),
      child: Text(_authMode == AuthMode.login ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ'),
    );
  }

  Widget _buildPasswordConfirmField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 2.0, // Độ dày của viền
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 400.0, // Đặt chiều rộng
      height: 50.0, // Đặt chiều dài
      margin: EdgeInsets.only(bottom: 10.0), // Đặt khoảng cách phía dưới
      child: TextFormField(
        enabled: _authMode == AuthMode.signup,
        decoration: const InputDecoration(
          labelText: 'Xác nhận Mật khẩu',
          border: InputBorder.none, // Loại bỏ viền mặc định của TextFormField
        ),
        obscureText: true,
        validator: _authMode == AuthMode.signup
            ? (value) {
                if (value != _passwordController.text) {
                  return 'Mật khẩu không trùng khớp!';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 2.0, // Độ dày của viền
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 400.0, // Đặt chiều rộng
      height: 50.0,
      margin: EdgeInsets.only(bottom: 20.0), //

      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Mật khẩu',
          border: InputBorder.none, // Loại bỏ viền mặc định của TextFormField
        ),
        obscureText: true,
        controller: _passwordController,
        validator: (value) {
          if (value == null || value.length < 5) {
            return 'Mật khẩu quá ngắn!';
          }
          return null;
        },
        onSaved: (value) {
          _authData['password'] = value!;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 2.0, // Độ dày của viền
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 400.0, // Đặt chiều rộng
      height: 50.0, // Đặt chiều dài
      margin: EdgeInsets.only(bottom: 20.0), // Đặt khoảng cách phía dưới
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'E-Mail',
          border: InputBorder.none, // Loại bỏ viền mặc định của TextFormField
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || !value.contains('@')) {
            return 'Email không hợp lệ!';
          }
          return null;
        },
        onSaved: (value) {
          _authData['email'] = value!;
        },
      ),
    );
  }
}
