import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../controllers/authenticate_controller.dart';

class AuthenticateView extends GetView<AuthenticateController> {
  const AuthenticateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        theme: LoginTheme(primaryColor: Colors.black),
        initialAuthMode: AuthMode.login,
        additionalSignupFields: [
          UserFormField(
            keyName: 'name',
            displayName: 'Name',
            userType: LoginUserType.name,
            icon: Icon(Icons.person),
            fieldValidator: (value) {
              if (value!.isEmpty) {
                return 'Name cannot be empty';
              }
              return null;
            },
          ),
        ],
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return 'Password cannot be empty';
          } else if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
        onLogin: (value) async {
          final error = await controller.loginUser(
            email: value.name,
            password: value.password,
          );
          return error; // اگر ارور داشته باشه، ویجت لاگین سر جاش می‌مونه
        },

        onSignup: (value) async {
          final error = await controller.registerUser(
            email: value.name!,
            password: value.password!,
            name: value.additionalSignupData!['name'] ?? '',
          );
          return error;
        },

        onRecoverPassword: (value) {
          return null;
        },
      ),
    );
  }
}
