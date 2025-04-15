import 'package:flutter/material.dart';
import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/Authenticate/providers/login_provider.dart';
import 'package:fullstack_app/app/modules/Authenticate/providers/register_provider.dart';
import 'package:fullstack_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../Models/user_get_data_model.dart';

class AuthenticateController extends GetxController {
  var _isLoading = false.obs;

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
  }

  var _registerProvider = RegisterProvider();

  get registerProvider => _registerProvider;

  set registerProvider(value) {
    _registerProvider = value;
  }

  var _userGetDataModel = UserGetDataModel().obs;

  get userGetDataModel => _userGetDataModel;

  set userGetDataModel(value) {
    _userGetDataModel = value;
  }

  var _loginProvider = LoginProvider();

  get loginProvider => _loginProvider;

  set loginProvider(value) {
    _loginProvider = value;
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      final data = await _registerProvider.registerUser(
        name: name,
        email: email,
        password: password,
      );
      if (data != null) {
        _userGetDataModel.value = data;
        await Constants.storage.write('id', data.id);
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Registration Successful',
          'Welcome, ${data.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        return null;
      } else {
        return 'Registration failed';
      }
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      final data = await _loginProvider.loginUser(
        email: email,
        password: password,
      );
      if (data != null) {
        _userGetDataModel.value = data;
        await Constants.storage.write('id', data.id);
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Login Successful',
          'Welcome back, ${data.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        return null; // عملیات موفق
      } else {
        return 'Invalid login credentials';
      }
    } catch (e) {
      return e.toString(); // عملیات ناموفق
    } finally {
      _isLoading.value = false;
    }
  }
}
